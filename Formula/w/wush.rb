class Wush < Formula
  desc "Transfer files between computers via WireGuard"
  homepage "https:github.comcoderwush"
  url "https:github.comcoderwusharchiverefstagsv0.4.0.tar.gz"
  sha256 "724a5b874fdf35856ece92d2967700e56c9f81e932893d5c7bf9ee8dce4fe128"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16cfed7a56476d418376426dd9a8343fbfb4aec3ab80a27b985fad241fce72d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcb2ed077de332a6fdba62e04e5bec0308214ec107fb28554b30d445f7fe9e56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "130c9eb5b96b69324ec7b3c593681b32c768d4d78f7b19d9fe563f2d471361c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd1ad38154172e585eaab529d187471921191e81eae4c1a10062c335569a019f"
    sha256 cellar: :any_skip_relocation, ventura:       "94e94cf8b8943dbc27c586cbfc204fec7d1bd86c08e49359a761e6cfa8502b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a2c936673fe277bd91f43f837b4d1fbfb399d8bd2cbc9225d647f54d76d3a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdwush"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      exec bin"wush", "serve", out: write, err: write
    end

    output = read.gets
    assert_includes output, "Picked DERP region"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end