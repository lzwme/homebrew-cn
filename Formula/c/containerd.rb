class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://ghfast.top/https://github.com/containerd/containerd/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "c213c8222ec2b51f88eb541cd75e5905b35ae7d0b82d6d812f0b8121d11131a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55ca39aae736fd6b33de4a6db606ee46ef106d7fef27fc7ac8897c6e0212c41f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8aa759fa39ed25938df9d693a8f59468c617cfa5412b31174e237cf36b054712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80689caf28f38fe8eed14b97d7dab1b7f8e9f2cdeeeb7e381f4a6950c9ec4e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd57730329fda483eda8eb3927b2d5d12ada22ee2d2344beb13486b20483d3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "da1fd1121e6814bbeb70926e6f89e74a96358a65117ca11bc918262c0f976764"
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