class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-6.0.1.tgz"
  sha256 "85eabb9251d85d3798b247b2bc0895ca111d866bfbf59533f64b2461b0d8649f"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f346cc5dad777d5ce139d25b8b6108814b77c2020393023eedaa93cdb0de3b03"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules"
    typescript = formula_opt_libexec("typescript")/"lib/node_modules/typescript"
    ln_sf typescript.relative_path_from(node_modules), node_modules

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end