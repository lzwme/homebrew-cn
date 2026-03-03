class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://ghfast.top/https://github.com/containerd/containerd/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "af5707a26891486332142cc0ade4f0c543f707d3954838f5cecee73b833cf9b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0850ba663dc8327abb6cce239020c9077e320787988288ae2c9abf3454e24a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097355bee19a21a1d2fd2a78fd0f06d48127525f808ff03eece6c4c10293bc21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8137c15e6528780e88964d58b56a3fe3f3603071ebd960f9241935270e436544"
    sha256 cellar: :any_skip_relocation, sonoma:        "473049b263fea41fe437092dff651952cebd7879710d1e456d7e203902744276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920271989e5c33cb7fceb0402414005fc06b00bb4d186c0ba7714496951791f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32a955582337a52580ad5c28d605b0930ea7945004686e6a38b2a068b99e6ec"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    args =["PREFIX=#{prefix}", "VERSION=#{version}", "REVISION="]
    # STATIC=1 is a workaround for the segfault issue on the Linux arm64 CI.
    # Not locally reproducible.
    # https://github.com/Homebrew/homebrew-core/pull/269867#issuecomment-3977167831
    args << "STATIC=1" if OS.linux?
    system "make", *args
    system "make", "install", "install-doc", "install-man", *args
  end

  def caveats
    caveats = ""
    on_linux do
      caveats = <<~EOS
        For most workloads you need to execute the following command to install OCI and CNI:
          brew install runc cni-plugins

        To run containerd as the current user, execute the following commands:
          brew install nerdctl rootlesskit slirp4netns
          containerd-rootless-setuptool.sh install

        To run containerd as the root user, use `brew services` with `sudo --preserve-env=HOME`.
      EOS
    end
    on_macos do
      caveats = <<~EOS
        The macOS version of containerd does not natively support running containers.
        You need to install an additional runtime plugin such as nerdbox (not packaged in Homebrew yet)
        to run containers on this build of containerd.

        To run the Linux native version of containerd in Linux Machine (Lima), execute the following commands:
          brew install lima
          limactl start
      EOS
    end
    caveats
  end

  service do
    run opt_bin/"containerd"
    # See the caveats for rootless mode
    require_root true
  end

  test do
    assert_match "/run/containerd/containerd.sock: no such file or directory",
      shell_output("#{opt_bin}/ctr info 2>&1", 1)
  end
end