class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://ghfast.top/https://github.com/containerd/nerdctl/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f39c34d3a285e087f2b2869f06fea343d8285ad9bfb9417b9c5b6dd4e78d6fad"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4c002625d1bac4d4863d261a096431bd5f3dc5d4e2a6779add3149c7b32c802e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24b211f327bf44329eba718fbec50aa41d0e924e4df401b0c904fd8e40f913c3"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v2/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"

    generate_completions_from_executable(bin/"nerdctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end