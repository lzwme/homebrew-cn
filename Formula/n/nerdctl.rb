class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https:github.comcontainerdnerdctl"
  url "https:github.comcontainerdnerdctlarchiverefstagsv2.1.1.tar.gz"
  sha256 "fb8dbdc8954aaf9dbf05396f51289a094a4927e385cc974bc410ecc3fcf16d03"
  license "Apache-2.0"
  head "https:github.comcontainerdnerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4649f0d0c5202c2657ab8b083e9ef443715d38df2a54332c86ca93e07c61ee4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b7f4da0cf2057b8bebff9826b5a55ca9ced45f3e36fb73f93e1b2bee468b339"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.comcontainerdnerdctlv2pkgversion.Version=#{version}"
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