class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https:github.comtypescript-language-servertypescript-language-server"
  url "https:registry.npmjs.orgtypescript-language-server-typescript-language-server-4.3.3.tgz"
  sha256 "4a0e1c596fe598ff07db9221bf851a96a691718d99a12a9d4637dc64604914d0"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bec63299439d68c64e8708c57a32baa931bb6c8406e6869597bcddccb1014fd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec63299439d68c64e8708c57a32baa931bb6c8406e6869597bcddccb1014fd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec63299439d68c64e8708c57a32baa931bb6c8406e6869597bcddccb1014fd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "bec63299439d68c64e8708c57a32baa931bb6c8406e6869597bcddccb1014fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "bec63299439d68c64e8708c57a32baa931bb6c8406e6869597bcddccb1014fd4"
    sha256 cellar: :any_skip_relocation, monterey:       "bec63299439d68c64e8708c57a32baa931bb6c8406e6869597bcddccb1014fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "086d02b72242797c29431078c399e4daf1ffa3c27bf48bf65984d09e86dc403c"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *std_npm_args

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

    Open3.popen3(bin"typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end