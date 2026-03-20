class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://ghfast.top/https://github.com/dundee/gdu/archive/refs/tags/v5.34.0.tar.gz"
  sha256 "e7ff370d682563b71c2da0ad3162ecdb17db988cb2d2b5c1708405d31e63e816"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e742cc70ab1daf8278f86c6ddfed4cdd8eb4c54110fb737ff77bcaff9312f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e742cc70ab1daf8278f86c6ddfed4cdd8eb4c54110fb737ff77bcaff9312f49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e742cc70ab1daf8278f86c6ddfed4cdd8eb4c54110fb737ff77bcaff9312f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b1c7e36f204d19b26e9941d4cbc75d51d3764e6a5d0d33648e694723c7fc41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb744a87ec28820e70e0465a847f5e187f98562e222378e785bae901d0d4793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ee8e0370c79b85e2b8f93463cfc52c5269cd7f8b3032b70bc98b2bdc211f47"
  end

  depends_on "go" => :build

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gdu-go"), "./cmd/gdu"
    man1.install "gdu.1" => "gdu-go.1"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir/file1").write "hello"
    (testpath/"test_dir/file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end