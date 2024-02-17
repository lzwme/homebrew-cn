class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.15.23.tar.gz"
  sha256 "0e8fa2a15f8783cda36c11870a22621cc28d7cb9da587c577248fcf20444759a"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46211e61ea1786490263437398aeef3f724875ddb31f225a4e2ada0aff9ebfdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e602bd59d44fd38f2ffd03115bc93e48d11ff5f0111367099f9fd6961cd3744e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7835f98f2d8b01acdb4578e16ac703d90f85f36e2a88a36ddc11bd44225a5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "70a98cd6c42c009716a7ed8fc5a8e5200fa91adcfd159f345da83c00755b6839"
    sha256 cellar: :any_skip_relocation, ventura:        "a38c1085d3c090270e7eb9ad848e4820f0b46ff3753e8984d449dbd7da7ed2e7"
    sha256 cellar: :any_skip_relocation, monterey:       "292385d623657eef85dc92df2ab7b04fc110c973db3236a0601f165949b9aa81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a39c57d4608b392ebb1f52228a1380ae1c96a016394c40063ce2ea07ab0a10"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumcilium-clicli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin"cilium", ldflags: ldflags), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end