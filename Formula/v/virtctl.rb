class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https:kubevirt.io"
  url "https:github.comkubevirtkubevirtarchiverefstagsv1.2.1.tar.gz"
  sha256 "e086860913a5470dceca2f5d794ed77234ef1e2966e85d3b64f0d57273659ece"
  license "Apache-2.0"
  head "https:github.comkubevirtkubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "325a16aba1eb524438edebb20d1ce14118797ec241142b4ae29f655fbb12515c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53240b7779b772cf142f700455f152827bc57201f7e696a8262bb752524f96d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e096c871092e47ddc2ee6778d313cfba4984b0a737ce90e4ca7d52a163be1756"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea70116fe7c86104a5a3c593656e546bd3c03172e4a7f9a0333456b5a1d382a6"
    sha256 cellar: :any_skip_relocation, ventura:        "7f35edfa5ccec5dbc4c2a35374760938b690642bc1a85bffbc859e9db24ebfa0"
    sha256 cellar: :any_skip_relocation, monterey:       "20234321f18f5e9ebbc098ddff19f25e9ae3a0984a863b7bb7907156abb00a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3c28af195e9538d012ba0c1fb6c578607cade9bb6b2a7c6b6f15020aef51cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'kubevirt.ioclient-goversion.gitVersion=#{version}'"
    system "go", "build", *std_go_args(ldflags:), ".cmdvirtctl"

    generate_completions_from_executable(bin"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}virtctl userlist myvm", 1)
  end
end