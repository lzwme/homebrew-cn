class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://ghfast.top/https://github.com/navidrome/navidrome/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "92499506f2da5bcdf88fed22c6018778391c18e839e66930e34bb5f9fff9d9dd"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969f931150849f2bea9e99181332181030aea880fa15f1e2be5aa730d9d72091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9572b3a3aaa6725e360d516f4febdc934b770832544f92ead5f2a4eb2303d861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8ab382a531dfeeb5cbe8400c10774d3d35771916a0d00fa9d1d67020d4ce79"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b29d5452c4c0c27e12f128acc1ca13de5ef7ec1714ff05da50965e5a2f99b32"
    sha256 cellar: :any,                 arm64_linux:   "f5722299c49f5c68add3f8436fd23b95559d7cebd33bee2908fe26471e607fbb"
    sha256 cellar: :any,                 x86_64_linux:  "08ec7d066eb782552c182d2a87fed160294bb1e84250c201e3110d6d276c87dd"
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