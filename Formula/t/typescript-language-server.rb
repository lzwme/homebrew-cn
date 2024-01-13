require "languagenode"

class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https:github.comtypescript-language-servertypescript-language-server"
  url "https:registry.npmjs.orgtypescript-language-server-typescript-language-server-4.3.1.tgz"
  sha256 "8e7fb16f8c9f4ac2371154efc9d73e62a94b99560c5b2a2e2d323f4d42fad2fb"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf68ac3b6962c535b92007fbd5bde34ce6f57362c6bcf14a364e337e4eb24ecc"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    node_modules = libexec"libnode_modules"
    typescript = Formula["typescript"].opt_libexec"libnode_modulestypescript"
    ln_sf typescript.relative_path_from(node_modules), node_modules

    bin.install_symlink Dir["#{libexec}bin*"]
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

    Open3.popen3("#{bin}typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end