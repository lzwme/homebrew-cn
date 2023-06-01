class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://ghproxy.com/https://github.com/dundee/gdu/archive/v5.24.0.tar.gz"
  sha256 "e7437d3618baf4370b2c19706dd0f33460f705715ff715b68dbcf2f0d5b1aa94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfd573c6862ff4cfd55ea9a30dfa7b18d7396f138b6814999ad6775e76532981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfd573c6862ff4cfd55ea9a30dfa7b18d7396f138b6814999ad6775e76532981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfd573c6862ff4cfd55ea9a30dfa7b18d7396f138b6814999ad6775e76532981"
    sha256 cellar: :any_skip_relocation, ventura:        "833d298a808f0e5f5f55f5727ceeaba64f74136b6cd063b90597336c541addd9"
    sha256 cellar: :any_skip_relocation, monterey:       "833d298a808f0e5f5f55f5727ceeaba64f74136b6cd063b90597336c541addd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "833d298a808f0e5f5f55f5727ceeaba64f74136b6cd063b90597336c541addd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdcabaad56eb52b1edf2ab81f61cf08eeed43917b3e0380fdb45d61814e0af6d"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end