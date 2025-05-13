class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.18.tar.gz"
  sha256 "227b14eeb47ca32c2222117e458a7986ba4e86f610efb340bb2b64d433498030"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c5663437b799d919b9678a8fd1826ab7be8ef518c3a27d5d6e274ffc77762a6"
    sha256 cellar: :any,                 arm64_sonoma:  "8eba3796496baf403e626fd18521948fc80613dcfb6b2aca0e501eb63c7a2a7b"
    sha256 cellar: :any,                 arm64_ventura: "0dd32320bdf35912300bb0c942d4071a77a7e1fa27515e1add13dfe8a7030f81"
    sha256 cellar: :any,                 sonoma:        "4bac869b856b5a4596775df01df95af4d225bf18ab2e31e843bf881cdeb48db6"
    sha256 cellar: :any,                 ventura:       "4e966963a4fb1f9e720e10490babfb9e164e02b151c628d2383aa608c3dceac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a2ac03f5a52311a79a380c5daa91aed7aa963ed86d7fabbf3bcc2aaaf46d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a99fbc08e0914664b19a9cb814394740db7df12aed5431433c05c22ba2529c"
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