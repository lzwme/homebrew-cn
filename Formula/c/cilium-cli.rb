class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.13.tar.gz"
  sha256 "dd41ce3281737e65af1780b5c6d47df664580c52de46fe48d5a4b19b9cce3c02"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dae11da29a3d9f90da7843546530a3ce14796695375cdaa24582678ec304cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d6a3641f9cebb5c924d7ac784597ff0b3824ba81de117a95f3f047d17ec39fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d57f841a64c8998b9fdc91d54aa069a6b8f5206d7b864f48ec3370bdb75b2233"
    sha256 cellar: :any_skip_relocation, sonoma:         "5454bddd0904d96a30fd66af407545156092b9985b4dff0376a8f9a4df6109e2"
    sha256 cellar: :any_skip_relocation, ventura:        "34c5db77643152e50fb0bbf86f7d7e5b0805982be39629088a59eed337b98bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e0502c3059adde19eb68efa88d10b26a21e5448dcb38741f992c4ca86ef604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c268a6d0e21cf9d8fdb471b54f442074963b71e9850d7ac99fb1605631cdf90"
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