class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https:github.comcontainerdnerdctl"
  url "https:github.comcontainerdnerdctlarchiverefstagsv2.0.2.tar.gz"
  sha256 "fc5868087b5dccfd329935b6072f2edbf368251e8d96ec1c6170e71e832205f4"
  license "Apache-2.0"
  head "https:github.comcontainerdnerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a7b27d7fc231717add1256eba6e43e58f5bb59c1a957677cd7948a8026db2e0"
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