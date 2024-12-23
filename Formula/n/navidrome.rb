class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.54.2.tar.gz"
  sha256 "fd78e335599c611a9f0e3a43bcc81ef093e86b3b4cf148b27678b93da1a795c1"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cda2f8231e02c160b3f7eaf5ae0447ad00da647d4e74e29c5f3cf4801832216a"
    sha256 cellar: :any,                 arm64_sonoma:  "ed806551de8e9da91c8ebe5c10378fcca62f5156a26f2335a36c449f4f9ac553"
    sha256 cellar: :any,                 arm64_ventura: "55702d367b503841eda2289ea7f045f843e5702cf0bd6d13b0cc8b65683a730f"
    sha256 cellar: :any,                 sonoma:        "a6960bb7820cdf5d4d2ad85f780eab704fc04b4170acada5ad8130d66690328b"
    sha256 cellar: :any,                 ventura:       "54c4131944d4fe95e161e8625d2799801327b8b7b7523d4b338f5ecd60519e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea54b7606448a987b60327727f631650a2c99aa09b23cb6255348bdd739ad6f"
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