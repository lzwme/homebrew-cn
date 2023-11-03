class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.12.tar.gz"
  sha256 "e072b5cc595472d1fa5e7cdecb5ff3a71289f8f6bba327bb3170b2a8100f5925"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a02c5113795ab0340e8a6f868ce0e6b56f8295c22e2422944151a440bfe19539"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6d8d766f9a3f5b2cad3d127caab697621b75e1538c39f174d7dcdb2258efbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6d52eeebf64f3d1ff14167e4fc6fa031641c47b53d778b38646cabb6e7bc43"
    sha256 cellar: :any_skip_relocation, sonoma:         "42364adce6fea74222646d11a3b936965a43e718812ca60e9e0326ada5c6d9f4"
    sha256 cellar: :any_skip_relocation, ventura:        "279f29e62711dd71e571366e9ad5e19aea237708e55a559f2d9043ca98c11579"
    sha256 cellar: :any_skip_relocation, monterey:       "4122d75f6f2c57ed5843004faca184527da80161979b0b4b1f5d1d8f5f7d9623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491f6b3dda9db498fc67f87324a13c854db71f379377bc1f77b9260ce2bf0313"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end