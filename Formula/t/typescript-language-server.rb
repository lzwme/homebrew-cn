require "languagenode"

class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https:github.comtypescript-language-servertypescript-language-server"
  url "https:registry.npmjs.orgtypescript-language-server-typescript-language-server-4.3.0.tgz"
  sha256 "6c73671208d0dd25ba369befdbdf9d317f193bc2fcacd6b417ce820c87f1921e"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41f34801b16bde4e51b7b8e82c4e9cb1ac0215f13b269053bff8659a51a9be0e"
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