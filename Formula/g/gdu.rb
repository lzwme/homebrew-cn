class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://ghfast.top/https://github.com/dundee/gdu/archive/refs/tags/v5.34.0.tar.gz"
  sha256 "e7ff370d682563b71c2da0ad3162ecdb17db988cb2d2b5c1708405d31e63e816"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be7ad505558a21d361f6d2d5269a15e646e0332ea3979c7e831425a3036e2b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be7ad505558a21d361f6d2d5269a15e646e0332ea3979c7e831425a3036e2b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7ad505558a21d361f6d2d5269a15e646e0332ea3979c7e831425a3036e2b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "75cca354c5ccf6c34821bd45ee3cabe9bcc028a0654e1fe206a2157eb1e42ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a606867bdb25deddc04d8cb37d0c4d2b1c8f918fd9eedcea2235e715f0f0b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880a65e40b06bbf21689630eb8f01a3bde69129d9a396f6c81b3730c4c260793"
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