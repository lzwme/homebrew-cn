class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.50.0",
      revision: "58f3b8d0f31a3bded0b1cdbb6b2934eee262f03b"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "04ebb482fd487735b9eb818f5c9eb178b47e5fec92eef6d8bc915af542be48d6"
    sha256 cellar: :any,                 arm64_sonoma:  "9aed84bdf1bdbde26c9e21b36b131abca04c31f10c5f8e4eb347306a33084b58"
    sha256 cellar: :any,                 arm64_ventura: "548aa4292d06afbc6864218c3392c9ca21733cb33e30b7a1c4d14d10a6d7a51a"
    sha256 cellar: :any,                 sonoma:        "ef6f572b7b4d655935802bae9c88419728e9ba568d250679634b927a69b964a7"
    sha256 cellar: :any,                 ventura:       "1161fae05d92235981af40869d7c38d1081d942c85c47fe6584ad7bbc1712bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d94ae8f22f2b69edb594fc60801f5fd32a4f8309c89fa6746afc327d0ab4ffb"
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