class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://ghfast.top/https://github.com/dundee/gdu/archive/refs/tags/v5.36.0.tar.gz"
  sha256 "40a8635452a333fc74d9f060c9b56b6ebc0c78911f0b6eff498e6303f03505c6"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26503034743d0993d395ee9b9f54104411d204c9f115144e387ec01cbaed9fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26503034743d0993d395ee9b9f54104411d204c9f115144e387ec01cbaed9fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26503034743d0993d395ee9b9f54104411d204c9f115144e387ec01cbaed9fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d1f22c59909ea77beaaba3d586592611e2f390f26ca4141767fb0edc473f51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43cd6e0713740de4191856bf9db52e981fa84e43a3223d9950091b98a704ffc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011770697349fe2efc32dcc124c79a52be07d812ae7bd95cacdb9b82639716a6"
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