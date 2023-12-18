class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.50.0",
      revision: "58f3b8d0f31a3bded0b1cdbb6b2934eee262f03b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4de169818f370c104c019f7c90ad134c1f88c75129c565274efc9c6d857bd80b"
    sha256 cellar: :any,                 arm64_ventura:  "fc34cfa5a627af051fe3c3fc622b8393c900a0cd5cb10c8e99be2a7c0f34e80a"
    sha256 cellar: :any,                 arm64_monterey: "bd2d83875ab54015bff63bb551f5ef7c62e3dec22ba254a5c905107b0a86c8bc"
    sha256 cellar: :any,                 sonoma:         "e851c6571e98f0478a9dad76944e81b69e63aa6476afdf99dc0041eb55dff9f0"
    sha256 cellar: :any,                 ventura:        "980a108be8c982b100ea34a8ac3caef40e18b54fa2b0c57792a3bc3699bd8fa8"
    sha256 cellar: :any,                 monterey:       "e8c27f1d6c6f57ef308874bfffe3c7a17e30024b49c3b25ce34dfd2f217d60af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba6bb1e937b5aae80f55af4722ccbed7d43776a2ed1b4c9747d781698d232a4"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  uses_from_macos "xz"

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

    Open3.popen3("#{bin}solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end