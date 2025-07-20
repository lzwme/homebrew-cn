class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://ghfast.top/https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "5e08ddae38f249bca468f6df9ce157876064809919980ed9343e7a6ac8cf89bd"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12029d5ed5aa76add4d31141c21624297c6e17ed98f00c7aba3c1bb850eb20d0"
    sha256 cellar: :any,                 arm64_sonoma:  "65cae1e85e7523d0e364481fc7026d122fba23e58d3f8c79159263b41cfb43b3"
    sha256 cellar: :any,                 arm64_ventura: "631eb6e984441fc1d8c7d103e1bda4a0a87ad2dc94e418c98c34c26917264772"
    sha256 cellar: :any,                 sonoma:        "bbf04ac30fc86ffc8fa768dc8d198d3164a3cd6a85a794e12084356d946de279"
    sha256 cellar: :any,                 ventura:       "a48c45aa5c5f8ee26a4dff1b54985962fdedc87c3a06eb01ec81bb5f54eca797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a241769d8428e62197e4009ec9bbe02206abbc75d83793e776fac867d79b6f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f94a1c77d6fc323e92061f1829457baf487d849875590bb0e2aa5d76f405a5"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files libexec/"bin",
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
    output = pipe_output("#{bin}/ruby-lsp 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end