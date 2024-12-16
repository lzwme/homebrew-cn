class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https:github.comsarub0b0kubetui"
  url "https:github.comsarub0b0kubetuiarchiverefstagsv1.5.4.tar.gz"
  sha256 "730ebe3a02af4e92a09bc79e94dc95949885abb6552775e7e492c277621d8c30"
  license "MIT"
  head "https:github.comsarub0b0kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12bc4b165611b7ec6f0559ab050c9753028a92f733f6fc47432a22f860730a43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cf812cd8f35532b6a7af47fdb1136abf3ddb01aa41b537e4428be2ce42a300"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33e1809841fd68bf2aa57695587d12feed1e5b53f071a253aa8aa746e626afd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "90dedd79247a40d7a1077b8bce37143ec5b7a48c1852b4eb7dd781a8ebf2d12f"
    sha256 cellar: :any_skip_relocation, ventura:       "13c00c0cb6b11fa6af7fbeee25aececfa863fe2be5e0bd155a0113acd3ce8964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b2eecb6b89ffc0502d7228003f5fd87d1af1d62b87d1c9cc4bc682cc02412e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end