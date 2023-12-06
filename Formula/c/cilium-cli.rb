class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.17.tar.gz"
  sha256 "2ba01efaaff90187764dd4fd747adadf7e9442f409d2a0ad113b8c3c2fabe893"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e849aed3ba565c423140cf730c1eb39e41f9e6a75ba03565afd97769309d00a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c7b94fae5120a08c7c4dd953431fd62859443caf939fe0c5823f4b691213cde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290d45f4c11edf505f1b7ec15a46fc014852e47b35866b6ed62132e13fdfc59d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cc55a90a41f438948b95a034a1f243a71481421597480bb99dd97a7a2c5b01c"
    sha256 cellar: :any_skip_relocation, ventura:        "e68dfb6bf5c653d0a71f9ce77ec712ad080e13a30f7ca71d095984d72bbdef7c"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4ef0d5baa754681333508a5fbadb55593a55c05c95ddfd921a12cd7a03fa65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf1ffec5f0073c3e783361ab523fd55f5b7fea581ae030282590bcdb1b6cd7e"
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