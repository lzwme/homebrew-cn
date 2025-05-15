class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.20.tar.gz"
  sha256 "d3776e435d1e0fb76b3437a1f153f6cb16c3efdb67b8dd58d0cf52c1b3c35676"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21879db801d138c1de9c25f07698292571a314d657f8589a0cf6461dcf2cc404"
    sha256 cellar: :any,                 arm64_sonoma:  "5fad2a52b428f5136897a5ace063fb7cc782c2a8d1e8346069b1b24533c0c528"
    sha256 cellar: :any,                 arm64_ventura: "b4e6532e3704f987ecd34f2546c9eee45048118540ff9785cc46154f89984e32"
    sha256 cellar: :any,                 sonoma:        "aecfd0d494be5c951cfa672bdbe98cff192d4d2ab851f53f1971ae1bc6affdd9"
    sha256 cellar: :any,                 ventura:       "c4d9c7b5e61d09f36538cc485ef7d04f591ed7da8e96eb673dcf44c6eafe6580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b77215e1d26175d24ae1270a310d84f67c4152e80eeb6ffa5b718293fee459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7991bd7d1869171053227f1f9891e9b1d1150ffb452dc777a921fb9d4d57dba6"
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