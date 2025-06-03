class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.24.tar.gz"
  sha256 "9044f0190c99d50bf1919da509bb12cfb8d6da4bf15742a5a691e16a71cbbca2"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "817b290ba0f251461700cf91226b22c79fb7ccf0424e65ee3beabf56b1a4f4b8"
    sha256 cellar: :any,                 arm64_sonoma:  "3924c5fa6ea13f7aa59d1db4460a2079b000003f45c1a14d1d619f2fd2715c96"
    sha256 cellar: :any,                 arm64_ventura: "5e22e0ebda5d11da4efba3c77db0809a296af2f98690ad2ceb75a4479d5821ec"
    sha256 cellar: :any,                 sonoma:        "08d393aba7b455fe9ec71d8f46127008b7b7ae8ff528447c78753fcbfd1d0b71"
    sha256 cellar: :any,                 ventura:       "43cca011cc3c12c686fda6d1be374ee095ae392420d2cd25834661b2d74ad217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d183e914e6a41f51e3ca270fe72174bb0a0e96f2c7359a8dfe930c745e62317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50bdc9fa86f6bbae887fd2562ac164cad392827b5159a163cc2c423bce2ec945"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
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