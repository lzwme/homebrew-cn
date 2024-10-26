class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.48.0.tar.gz"
  sha256 "ee06df442547d9262f287407b2256b37a87e8469888ef926e26bfda3fa367f09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dad988bbf3c17ba73606246efb2f9bd46b87d460faa440776e5458372b5ab15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dad988bbf3c17ba73606246efb2f9bd46b87d460faa440776e5458372b5ab15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dad988bbf3c17ba73606246efb2f9bd46b87d460faa440776e5458372b5ab15"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1a24be3c67afb243ccb762ecd39700d68101ba1faa44ad5040c7a9b69b6520f"
    sha256 cellar: :any_skip_relocation, ventura:       "b1a24be3c67afb243ccb762ecd39700d68101ba1faa44ad5040c7a9b69b6520f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb2cc3fd75692c1cc52294f5f73836be92c2732f4ad0037262c1314e107ee8a"
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