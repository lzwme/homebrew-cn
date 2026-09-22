class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://ghfast.top/https://github.com/navidrome/navidrome/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "aeea3e4570a29105bc09957da47f3d969700352bb846ba9ff8f1ddff69d31afe"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4e2c3aed555fdda4e21de4903f371ca640873f445636f9d2f5f680ba0bd31b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3cfe0b044c25a0bf1b990b7effeebf3263fa9fae8a687f1802ad57bf161e13f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85e1efdda9210186e0307f261f0c2a62fd2bd8d4be1655cbcde65da317688954"
    sha256 cellar: :any,                 arm64_linux:       "236728253b0bc9a1e7cef8f39c6c88882ea2942e46f07497ac84fbf04e0a08f6"
    sha256 cellar: :any,                 x86_64_linux:      "c30199eb0ea9163585fd98624d26b360729084923387a9be1c85b4849fae9491"
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
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end