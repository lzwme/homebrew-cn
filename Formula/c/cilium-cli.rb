class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.16.tar.gz"
  sha256 "2fd62feaffe684f88f5083cf9dbf91df65c0ff4e701c96b05e0b480415588102"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7dd655df45e0e40255cc8721708bf3a8198d0b49b14529ac49b303756399a89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f7f9d27ac1dc2bf2a75ea2ab9177d08a5b6d6e50272e43bc8645b3b38e54931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "988dad18fa4d162376e852c1e5fb56ffcd2d1623ef21d85a8f96b9fddd2eb957"
    sha256 cellar: :any_skip_relocation, sonoma:         "739f65bc63568c8ee4d20ad8498d91398bcd4a36eb122dea6512a0416cde05fc"
    sha256 cellar: :any_skip_relocation, ventura:        "e252adde5b94f45867ce1c2c2737604d32e9eced5bebb4327f4206f389ea01d9"
    sha256 cellar: :any_skip_relocation, monterey:       "7666f99ad340b4f811d33b1327825abe6b9b29b1e7b55218a9861a5af6e99990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c164d517ffb7cc1a69e30844387989513d4c290eeb8bd9abc604fc31d0e3a2d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumciliumcilium-clidefaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"cilium"), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end