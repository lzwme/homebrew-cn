class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.44.2.tar.gz"
  sha256 "02ae59e9a7ea741d80c509423151287abe5a98a2337d8db406de402b17ba3997"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f290756e9ef61e2819c18c88a9ed1fa4f082ddab6089c0ef6b613f14ea02a68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "234921a530c86e99283a315e3f883a1e03e3e46c5ad00cdc4b752ed45add60cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "508bf790f62335ca4d30e4128b6026adf93a5f27feff4ca3eb5fbf59acdf03f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cc0b609be08fe7230dcb77bd9a6204e0718d4b2f7a8e5a6cadb4c9e9d771b0f"
    sha256 cellar: :any_skip_relocation, ventura:        "20ab702d725588577c5dc66767fb5140e0eea9d713c95f5fa8e722559cd42371"
    sha256 cellar: :any_skip_relocation, monterey:       "d5d8116e435717ddfa694a1e311a33272cbe874d6bfc786e7651b49f0cba690a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d10eda5427c0fd8254eb5a0611fa21ac0f72e5699b120a74eda88abc220698"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhetznercloudcliinternalversion.version=v#{version}
      -X github.comhetznercloudcliinternalversion.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhcloud"

    generate_completions_from_executable(bin"hcloud", "completion")
  end

  test do
    config_path = testpath".confighcloudcli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}hcloud context list")
    assert_match "test", shell_output("#{bin}hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}hcloud version")
  end
end