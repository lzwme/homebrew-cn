class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.21.tar.gz"
  sha256 "09cac0e3cce986d3c9b71893f7514c8547c8e3f1c73495b7dd926198a9428d1a"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "064e11a67530846e3638f6b1c5877118b8b286f57459db9518a27e03a4349ba5"
    sha256 cellar: :any,                 arm64_sonoma:  "13c1eba725eb2aadab900c8d24092b201812f5cc7d28d8f815740636553dea96"
    sha256 cellar: :any,                 arm64_ventura: "877d8b0d824ade069639088dabf96b8c58077444726650623ef7537b9d372b9d"
    sha256 cellar: :any,                 sonoma:        "e3737b61ec2cdafdc9804bd3a85b853195042b305bc7ba59a29be9142d3df91a"
    sha256 cellar: :any,                 ventura:       "afb46683f319fe97a2a98a1696076342ecc0fcd66c1afece580ae14c24561e1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfeffd8f28f7346f99502f5242efd33483e9e4358a6965d81821ee426d8ed45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5346c090adc80ce89ce5eca74fee1f4d3fcc9c167276f27097da6d76d23920"
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