require "languagenode"

class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https:github.comtypescript-language-servertypescript-language-server"
  url "https:registry.npmjs.orgtypescript-language-server-typescript-language-server-4.3.2.tgz"
  sha256 "7343baa7d31dd4a3da75ba2905b2d01f23d3d252b706b71c6744f55b28b46321"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85e5459958b9602419257512468eac2f7fcbeea0e5c4abc8b355f60da9b10531"
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