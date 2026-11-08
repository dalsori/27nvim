require("mason").setup()

-- Native LSP, with the language coverage of the previous 27nvim setup.
local servers = {
	lua_ls = "lua-language-server",
	vtsls = "vtsls",
	eslint = "eslint-lsp",
	oxlint = "oxlint",
	cssls = "css-lsp",
	html = "html-lsp",
	tailwindcss = "tailwindcss-language-server",
	jsonls = "json-lsp",
	emmet_ls = "emmet-ls",
	intelephense = "intelephense",
	pyright = "pyright",
	ruff = "ruff",
	gopls = "gopls",
	rust_analyzer = "rust-analyzer",
	jdtls = "jdtls",
	lemminx = "lemminx",
	clangd = "clangd",
	sqls = "sqls",
	graphql = "graphql-language-service-cli",
	buf_ls = "buf",
	marksman = "marksman",
	yamlls = "yaml-language-server",
	taplo = "taplo",
	dockerls = "dockerfile-language-server",
	docker_compose_language_service = "docker-compose-language-service",
	helm_ls = "helm-ls",
	bashls = "bash-language-server",
	powershell_es = "powershell-editor-services",
}

local packages = vim.tbl_values(servers)
vim.list_extend(packages, {
	"prettier",
	"prettierd",
	"oxfmt",
	"stylua",
	"shfmt",
	"black",
	"php-cs-fixer",
	"google-java-format",
	"clang-format",
	"sqlfmt",
	"gofumpt",
	"goimports",
})
require("mason-tool-installer").setup({
	ensure_installed = packages,
	auto_update = false,
	run_on_start = vim.env.NVIM_TEST ~= "1",
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = { fileOperations = { didRename = true, willRename = true } },
	}),
})

-- First installs are asynchronous. Enable tools after their install completes.
local function enable_installed()
	local registry = require("mason-registry")
	for server, package in pairs(servers) do
		if registry.is_installed(package) then
			vim.lsp.enable(server)
		end
	end
	if vim.fn.executable("dart") == 1 then
		vim.lsp.enable("dartls")
	end
end
enable_installed()
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("ClainevMasonLsp", { clear = true }),
	pattern = "MasonToolsUpdateCompleted",
	callback = enable_installed,
})
