class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https:github.comcontainerdnerdctl"
  url "https:github.comcontainerdnerdctlarchiverefstagsv1.7.4.tar.gz"
  sha256 "9d4f83af76297c654698c653aae33933e6aaf84ff109636b2a5b14d59cef8079"
  license "Apache-2.0"
  head "https:github.comcontainerdnerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "446a782f11427c9d00befbe3913794c915f3a21b2a6cebe083b92bbbee57fe17"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.comcontainerdnerdctlpkgversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdnerdctl"

    generate_completions_from_executable(bin"nerdctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=devnull #{bin}nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(\e\[([;\d]+)?m, "") # Remove colors from output
    assert_match(^time=.* level=fatal msg="rootless containerd not running.*m, cleaned)
  end
end