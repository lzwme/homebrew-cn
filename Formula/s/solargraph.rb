class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.53.2",
      revision: "1f8a6f7575c3b34783fd18c96da7448de46fde0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e62e12d27832339e17de9f2d3e8987848483ad3f0b6ee0531cb3f7191dff4a5"
    sha256 cellar: :any,                 arm64_sonoma:  "65fb203c0b5f15f9d002c1f0937df6cceb5eac0dd1f4bcbceeeac7efdcc322a9"
    sha256 cellar: :any,                 arm64_ventura: "9f1a72d8513a60fc5dc6395410c7a0c5eeffab711470d41c2730deddc5f65557"
    sha256 cellar: :any,                 sonoma:        "87bf1280fe991aa19750e9733c9c66fef81002a64312fe1f0ca348864ef44080"
    sha256 cellar: :any,                 ventura:       "45b642983071703cb8666fd736a56cb029ac109098016d5a130ca662e66b5987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6f740548d2e60a143f58131589c50300b8898e764f7397774d11f2b2ee36757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f547a62c98288e66b8a73ab99c9077ba30b8ea562346b0981d58609b2d9261"
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