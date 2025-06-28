class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.55.4",
      revision: "3259f2678ca3fb980f6b3a9cb009594dc98d3415"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30e2da31fb0c752d21ea95889c23d62013c4a912765dabd7c24d227ec6fd34f4"
    sha256 cellar: :any,                 arm64_sonoma:  "1d035d715bf1f8cf849c46978d45f29f1a7e797dcf7f440e268695921fd60ce1"
    sha256 cellar: :any,                 arm64_ventura: "43f6d8c5d72d67313e2c24fc6162a33ee6c5c9f19987ce9a4d2d794e251d8fe1"
    sha256 cellar: :any,                 sonoma:        "33ecfb72a4899a819ac088d3dd03eb565b81910555b20d50c1600241ad7fde5f"
    sha256 cellar: :any,                 ventura:       "1452cddb802302356745a2e5d788c7dabe7f80d498c11dc971c0e84ed6f388f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e186a7f50f6c9becf6e8bc01c8d38d4812dbff59b2b40e10a64e0268ae04740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c190f85b818af22fca2e141744c9cfca04239b48b0a31303b26c633ca5f341"
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