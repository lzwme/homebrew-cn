class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.52.0",
      revision: "1ba47849f81813428b4144ff8320b59d5277a378"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "43f48accdfccc507fe348fd63f1052d0de029bf4895330c0ba07b578be130b2a"
    sha256 cellar: :any,                 arm64_sonoma:  "be92cbb5c33820cc74fa52a4378cbb1aa1a4b9fd42f9e553034cd255ceba93cf"
    sha256 cellar: :any,                 arm64_ventura: "0300f2bf1af3e8e3a5abd88ffe6be107d9707f4fbc9ea319f6a104340d2cd03d"
    sha256 cellar: :any,                 sonoma:        "766da144671b0e3051254b616697c818ee64872135f7aefcff3358ca6a089f6a"
    sha256 cellar: :any,                 ventura:       "0faf97bec7311e2640b1005864bd1f401dcdb992333947013dbccbe48306fba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d165897e868a4472c071cc998cdb779a1a07162a3a4c79f36b2186ea796bd4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ed1766c1e719f4631c2602aab068045259588d92bce0a4c5a00a3b0b16cacc"
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