class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.12.tar.gz"
  sha256 "01c8193c248bd55833291983ea7597b45dc54187b8e85c36b12783c58ffbc7b1"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcb7b9a18f20ad2fa9d74f25e8ae5e76bc611b81efb6b3d12e4aee0e0ad9c342"
    sha256 cellar: :any,                 arm64_sonoma:  "7d66a0e4dd44e78ecba57e73aa7b2d23694cdbb058a2ff332ff6bb5f3671ec48"
    sha256 cellar: :any,                 arm64_ventura: "00ec0d97779d8cf3e3573258ecf981c6ab732a8acd6bb640f95b8392fa21c261"
    sha256 cellar: :any,                 sonoma:        "ab1046204bcf3caeba13668a82e4f860e19f94b7a8384e456f51b1bf67607f77"
    sha256 cellar: :any,                 ventura:       "48aeba22f1130e70a774a6028a2ee4aeca4559ee1e851728dbcd3d383165a2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c3a46977d022c8f86effe5271b3cad99910506ac44730e781551e9f385f675"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "bundle", "install", "--without", "development", "test"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files libexec"bin", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}ruby-lsp 2>&1", input, 0)
    assert_match(^Content-Length: \d+i, output)
  end
end