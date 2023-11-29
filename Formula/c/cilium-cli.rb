class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.16.tar.gz"
  sha256 "74a0e20e6ae00ea77ca1c69cd73f01077be05405fc7d0ee012a7706424f832c5"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8e71df63ecbfcb8a79a2a046096ff5123d6afc83487deac09a13ff153026d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2b30a4f969a945cec52a18f32799c5a78cf20f3463b4c905c408e8f4c4a4f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c920650a157a8bbdebbfaa1d83da84e3762ccecb34f8d9ce7398578517162e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "704dd9f0e01a6830e6d61541f17fa80efda6fc64568cad0f04ea24dd1f5fc8ad"
    sha256 cellar: :any_skip_relocation, ventura:        "94bfb8f8f5c7d85f982f7222f2423be44ceb11e6fd58bc50df6422c526778cd8"
    sha256 cellar: :any_skip_relocation, monterey:       "575911f12be5e46a389c7bc7dafef49a5cd4ee851532f0ebeeab74dadb3f1f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f237ca062e222ac2e83e076046c3afed2edaddb8cc01f7aa48656715c91bfd5a"
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