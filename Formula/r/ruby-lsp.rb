class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.19.tar.gz"
  sha256 "a4b1cb46940800fff9ab357f737fb50f1631f5eab2d9cebe25ca94e6852f97ce"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "594a56cd3590b30ece45356d6b9b2d37224d15affe507609ccdafd335180067b"
    sha256 cellar: :any,                 arm64_sonoma:  "119507bdf39763fbc168d04da7348a5653d8da2175fc8fa3e20bc99a6605c1da"
    sha256 cellar: :any,                 arm64_ventura: "8ec8df73070dea6c14d64162ca18d99c72ca53208ceeb577c9ae74882b498a13"
    sha256 cellar: :any,                 sonoma:        "106b36060d228efd5f2dc9567ed460660aac9455e037ec8231ffaf3d4abfc779"
    sha256 cellar: :any,                 ventura:       "23578db4d5c43a79878cd3716d3bd523da4964a45b5ceeebf6d3c3bd72dabee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef4a9daadf992cdbefe664d5199d957bb1eb7c729543dd983da14597f3639a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3beae4c6c2777c3ec84fd3d173743438338345356a750f880254b93817012c"
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