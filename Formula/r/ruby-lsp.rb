class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.11.tar.gz"
  sha256 "9418306eb45500b9cfdef0b09338c766e329aae6903055da4fef47e6daeb54d2"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb25c4d0be9ae21b8ccc5bdce7d90f3a79b808053622290f313c373497eb2207"
    sha256 cellar: :any,                 arm64_sonoma:  "e21081756ff22dee714d30a73c6f768ebe934e4bc057717a8f0b22dbc1b7f4ed"
    sha256 cellar: :any,                 arm64_ventura: "82fef2d6890acb2e9ab28b37b00fd96696239a6b745d8afdf56c36d84ad58f9b"
    sha256 cellar: :any,                 sonoma:        "dac553d6dbff95df160792474dad8a9d583a54cad29b134cc3ce03e271c46309"
    sha256 cellar: :any,                 ventura:       "d1808027e8a7401f528423ae76ee37b566c584110f66ba14be02bf1c669f9177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0113fa4be829cda335686cc51677999369f247ea36f1f946f7840f31830625ef"
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