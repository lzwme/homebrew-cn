class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.94.tar.gz"
  sha256 "5ac9fb7e48da618931bd6d5e2b4c7093838389573310432b10faf63e2d2b8b05"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8688c70c487b5072733c6df65bf6fac4ba500ec5aee14dfd0c35876ae63706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973ad36c604f1b4f34128b8b0a06622ae2046991558f94fc897073ce3c163686"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dfaa34bb3e445bd951d2460c052d9db1ee479b7923a4dbb0429132eba6e7dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "957165fc1f828d46706bdafc0abcd79ec7e77de29de9246960ccb3b3d4dc756f"
    sha256 cellar: :any_skip_relocation, ventura:       "918044dd3e972d0f61a102b92d9f4fc0b360d6d541a9d955d2edf14b009055a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d639de56b22974b5aae6382a5f159353414b9555f2ae2a7c34bce48bab538f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.comkubesharkkubesharkmisc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.comkubesharkkubesharkmisc.BuildTimestamp=#{time}"
      -X "github.comkubesharkkubesharkmisc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end