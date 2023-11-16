require "language/node"

class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-4.1.2.tgz"
  sha256 "0adb936229a44d2d07205d28f95f97a97614faa49f8dc42a6bdb2e323e299841"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7973f04b73c0967b35d335837e34448694f0dfbd88284e565db9077509ed85e1"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    node_modules = libexec/"lib/node_modules"
    typescript = Formula["typescript"].opt_libexec/"lib/node_modules/typescript"
    ln_sf typescript.relative_path_from(node_modules), node_modules

    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    Open3.popen3("#{bin}/typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end