class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.17.tar.gz"
  sha256 "73a4ffe9fca491e97d0d677ac6a54b1b932ebacc3981477fc800966c7cceecbb"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54d27e0f776db716965820144ccc7d38b8f0384969d19cdf722874b343a254b8"
    sha256 cellar: :any,                 arm64_sonoma:  "e3d1ea584e3bd00eb536a18f87edfab40ee9f2be0343eea5100bfcb1c46c9c3a"
    sha256 cellar: :any,                 arm64_ventura: "b3c4767152554922f19f3235cf40e8a01a5038f917bc221b0505d94fc81f3314"
    sha256 cellar: :any,                 sonoma:        "fd023a463c91105e170b029122d6be931c11ff611790a63ab7ed20533ebea73e"
    sha256 cellar: :any,                 ventura:       "77228578f96a1633b91727fd9318abb6c812ffb6d765dcef971efd36c9f46fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5222f0e975691f20726c6e016290c3029aa3b58285f2d308f9c2a72b612483d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45381807b898a11d958b5001365a1911b977c79a132ed12dbf62ec7164524ef"
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