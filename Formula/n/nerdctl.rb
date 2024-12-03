class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https:github.comcontainerdnerdctl"
  url "https:github.comcontainerdnerdctlarchiverefstagsv2.0.1.tar.gz"
  sha256 "916d67ca74f343f6a169caed3187a71c338c342deaf253101ffd4e04e7a43d8b"
  license "Apache-2.0"
  head "https:github.comcontainerdnerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9576e15e792742dc0bd646107a721ef93e57b9a6f6c43a41d3a004aeb9619be8"
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