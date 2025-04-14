class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.14.tar.gz"
  sha256 "041c25747d333c5aa934c527815a95df990a0ee1c7d6e489c381257b8b4be8cd"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45eb9a365dc2ca076dfd3b2e30cca9772cbd8cd8726858502b83bcc726ae07f4"
    sha256 cellar: :any,                 arm64_sonoma:  "8084f212c630908edf6d7050d462ba2212377bd1b9bf254c7083814f3ca35b1a"
    sha256 cellar: :any,                 arm64_ventura: "fa5368569a290fd2ef7ee90fdf8198bf4fb22199b047346c10036cd2ab3f7dc8"
    sha256 cellar: :any,                 sonoma:        "2d19a5e38d110bc217ea984f5fb6d59f45fdf56cf5b60affae47ef60dbe4d892"
    sha256 cellar: :any,                 ventura:       "98ac6b344d46ff347ade02fabf324e840c00a3e2e4cd5678725ac771fe221c86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705f10675161ae8ca02f720501187a43850fb0254d741f1644434c9814b0acad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f45b33bc2d8b8ca0b81519f6fbe037e1784a529c5baf8d996ef76f523c8d99"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "bundle", "install", "--without", "development", "test"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"

    bin.env_script_all_files libexec"bin",
      PATH:     "#{Formula["ruby"].opt_bin}:$PATH",
      GEM_HOME: ENV["GEM_HOME"]
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