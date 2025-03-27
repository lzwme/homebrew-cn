class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.53.1",
      revision: "0e82bbdcc9da7343dd028373797f2fe0373dbf6a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47669d2521e737b17ebfe8f88899816e4ae083a32c8da92c0f8e7e6b845592a3"
    sha256 cellar: :any,                 arm64_sonoma:  "2ef55b257fd25f0af57736fc89efd4679b0c308efd16dac520494658211cf50e"
    sha256 cellar: :any,                 arm64_ventura: "d62a970fa9d61c5f8710ec379f47f530b375b0750367e51a2d47d0ab513c4702"
    sha256 cellar: :any,                 sonoma:        "ac0305a94265eb4425c569f114ea786821648547aa8337a74adf8cd47cfff25c"
    sha256 cellar: :any,                 ventura:       "8ba129debf8b176037dd66d8b09f0f74886564561e065c40c49c42f0e8dd0c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f20b1e4bfcb5f521022d34a05e539783bcd63a6f52ee39c0bb0b34d12108f3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b42ca23672cd63546a59f40396dc6afe54a1252e573996336789b6f7778509"
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