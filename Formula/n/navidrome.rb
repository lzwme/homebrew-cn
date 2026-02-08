class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://ghfast.top/https://github.com/navidrome/navidrome/archive/refs/tags/v0.60.2.tar.gz"
  sha256 "1189697b8de66d443fea512de20c2a7064a985e171c6f0ff0cc8f0d7fb496e68"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9c511175254f88bb00596b10666b336ff6d1c81dec2f1283c216dc31a4ef5ed"
    sha256 cellar: :any,                 arm64_sequoia: "f2b121c87efdf2b75327baf159e0111c83628434db2ebebacd1f68faa884ec90"
    sha256 cellar: :any,                 arm64_sonoma:  "bc0ec620c17494c2c7ac27c3cb3235b45ac1d56be29d2a7e43c40807183b41f6"
    sha256 cellar: :any,                 sonoma:        "ea3440d0fff50f48ba8b8e667c4cebd7145b8d7bc368e04e884c16502c3c87bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6eb4eca01fb7403d2361bcebdb4b850cb03c6a05868f7269eaeff2a41473d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12207046bfa737351b74fcc78ef738cdf9c345322dd29a063c63f3fb7e07333a"
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
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"

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