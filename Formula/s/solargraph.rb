class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.57.0",
      revision: "9c707a291291ef6b86a030bca80b92b4cc3de7d0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63101bffec08eb9253262eed21549333a101961ed2a626b4645f3370685973e0"
    sha256 cellar: :any,                 arm64_sequoia: "be219604f3d28f79d26c23473ee99dc6fbee5e2faebbd4188df9ec5917b50f45"
    sha256 cellar: :any,                 arm64_sonoma:  "d629b4cc849afa5caea8be1cf3d16e40efd47da01321beefc5b253df417a6256"
    sha256 cellar: :any,                 sonoma:        "60f0678928771655ba5f06b09efbe7e84bfd997b5317113eec6dcc2aeba70959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d57da0e76d452bddbcc8a73b0d1d2fa331429011ccd29286d4b029bf2c1764e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0c185e820b08014e35583e5f74c5ffb2cdbb56208f34d5c2da2aca75198f587"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

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

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end