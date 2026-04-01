class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://ghfast.top/https://github.com/navidrome/navidrome/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "818e2e80845b18cf17f4b3afff7d889f51abd814212ff672a1587c6f62fd4e4a"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11ae88f27ab771e603617fe631d2ccac5f614e08b72feca2bf28e7dbe2a53d42"
    sha256 cellar: :any,                 arm64_sequoia: "36bdd7011349e7b205954bf15ed8453261d0f92ba220e17a72212abf70404f82"
    sha256 cellar: :any,                 arm64_sonoma:  "7128f7e141755d16f0dc090b812001f4485b96c1a07fdc2b2aba6c8c3f3611a9"
    sha256 cellar: :any,                 sonoma:        "8f85d873e9fe0373ea1ad7ebbcddb581385392e820b318fb74f731c8c00766c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb786d259384c79aca7ff7bc8ee81b6e5f86419cc845eae685c10f73863528e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e74aac36ed37b78c4ec8bd8b9912134812c6e331d86755f55ae6351ab2a9956"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo,sqlite_fts5"), "-buildvcs=false"

    generate_completions_from_executable(bin/"navidrome", shell_parameter_format: :cobra)
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end