class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.60.0",
      revision: "8220adbb75a404cf4077dee6f8f99e2d63ebfa23"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c35fad2d21c04b247807f8ad92114cc4e7ff3caa914ce210b3f78ab7a6e2eca7"
    sha256 cellar: :any, arm64_sequoia: "87074cefa2a25e944f3b1f7851cb0b313b52ee2d680078302c94e231c77da1a6"
    sha256 cellar: :any, arm64_sonoma:  "c24a2258c849c57d04dd428ded2c3725a3c5046d6fe3e52de83933f0b67a896d"
    sha256 cellar: :any, sonoma:        "139c44b7a2104872e4cdc20e73828ab211279ef8ac9467c2b766148969dee36e"
    sha256 cellar: :any, arm64_linux:   "9b04b83bdc0df3a8d218178ba7f4bcdfaaa2f4fdba58c64a0f99cfeeba01ad57"
    sha256 cellar: :any, x86_64_linux:  "28d99c7863be18263252ed33cbab0048c771de8a4706b986453c9cb0aa85c7cc"
  end

  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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