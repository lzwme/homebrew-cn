class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.55.3",
      revision: "0021d725088944f37183538595864a3c079b6fda"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "60b13326b0db2f666f5386bca9fa6f284fa37273b3cc628d3a8baa531a3f921c"
    sha256 cellar: :any,                 arm64_sonoma:  "af6a91eff9bfff02ea3e2118f9d6c32cf97859661547cdd3b5859b1f8713ef3a"
    sha256 cellar: :any,                 arm64_ventura: "2d25c0d9ddea26ded79795495bf7ef51f43c7f317768afda4b29d7270bc72794"
    sha256 cellar: :any,                 sonoma:        "f67335d064c16634e7cdbcb84eb4eb5fe45b97add3b97aa7e46636a640e725dd"
    sha256 cellar: :any,                 ventura:       "6b98025c01d709ac645b8316f06ce5c42f6fe5b973a79f8a43c782bf2644a1b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a88c145c85c43b9e404ff71a04e8e3a249e9a33e3b804d8382f0e65fb4dbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53bd82ef1b5df84838a26b90668c5836c2381fc847ed12e549f0f17f26086df"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
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

    Open3.popen3(bin"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end