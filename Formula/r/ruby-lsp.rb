class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://ghfast.top/https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "e764f4ce0d4f3fc603ff24121d85a025934dbb615b8d53950003b26054b13dc4"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea962993b359c1df58a52c330e38e6fbffbb2030dec7a744d119afe7e3dcfd46"
    sha256 cellar: :any,                 arm64_sonoma:  "40d06ea967092965bfab6131b66b13cdfde409c5e3f6caee2fed56d7b8320b9a"
    sha256 cellar: :any,                 arm64_ventura: "75062efa7fca20fc295b89ddb80362a2510486a2c44dbd611a2d68a84330cc50"
    sha256 cellar: :any,                 sonoma:        "c789fc224805afc04e922bcf1d6b8d71da4b6ceb82ddfed90a938fd670fc5e55"
    sha256 cellar: :any,                 ventura:       "b7ebdf9bf8419fd0c4219f1758e112094566bc041bd411271a5524586df6a97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de4df8bce866cb9b99cc5ab0d26560fa05d125a9949ecd0aec9c2367f3da19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960a8fe088e0c7eee815b073653065c421d2bbccfe312e146bfcf386bd2fd2d3"
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