class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.54.3.tar.gz"
  sha256 "d8d1a6697ddeb28ef60b8c04da1026f3bf15aea6987e04f524c7f548ed06c100"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a35464f12d4ee90bff8049a22a1fbba51d0c5be0921926225e6614c19daa83a"
    sha256 cellar: :any,                 arm64_sonoma:  "b231e9d3dda3b1ef6a2523cca591015a7eef8b1ed207be9d9d03b7e4a66df740"
    sha256 cellar: :any,                 arm64_ventura: "db1171f905b0597c30585b488ab53ca92144efdd0ceda0ef2e861b3061a0049e"
    sha256 cellar: :any,                 sonoma:        "1595242c02cc0f2589f7abf3c9d43d99c76da9e2c443cd067986ccba782e72c3"
    sha256 cellar: :any,                 ventura:       "c2a7829d0ae5cce42f38b9957bb8c030e41464bad26cc42ad4c481cf3126cc61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa59487e8cdf24705ca67b02a86b39605edef18bbe455f10163a6d953bfc72d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    ldflags = %W[
      -s -w
      -X github.comnavidromenavidromeconsts.gitTag=v#{version}
      -X github.comnavidromenavidromeconsts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:), "-buildvcs=false", "-tags=netgo"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}navidrome --version").chomp
    port = free_port
    pid = spawn bin"navidrome", "--port", port.to_s
    sleep 20
    sleep 60 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http:localhost:#{port}ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end