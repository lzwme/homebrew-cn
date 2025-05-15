class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.54.4",
      revision: "8b25f44b49e19094fbbff8acccfd8b21f9916155"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78d04761186a1d0d097265bc3ab8aeae9701c0a7ca30dfbcc605cc23639d2727"
    sha256 cellar: :any,                 arm64_sonoma:  "e49d2ac03caededa752e5b701a89c9edcfb2a00c90d70aae834cda04d716aa69"
    sha256 cellar: :any,                 arm64_ventura: "4765f90a84ace3b14806fb0a5638b9f43b96900100df7f3a7a9abf624b689965"
    sha256 cellar: :any,                 sonoma:        "8eeaa3b07a9f90f4bea290067503d39f45b44515a500505d25aa0608dee34b83"
    sha256 cellar: :any,                 ventura:       "f82d4aa24d5fce711dcba65f9e5bb10d1f8823df1be318d0f5eb3d16c8c05e76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9d20233dd51f8fb116f4456f157fcb2f96a195517fc69491b47eb7d4d8218e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e292945506e57f999d6b6f0a93a20d89bad4fdf3a6d4db16edfc48c82c788d"
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