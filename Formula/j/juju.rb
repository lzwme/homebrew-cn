class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.33.3.0+downloadjuju-core_3.3.0.tar.gz"
  sha256 "5bf5a6f85ff388f7c625697dc794750bd60a504f3876c509b136dd6600bc82a8"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https:github.comjujujuju.git", branch: "develop"

  # We check the Launchpad download page for Juju because the latest version
  # listed on the main project page isn't always a stable version.
  livecheck do
    url "https:launchpad.netjuju+download"
    regex(href=.*?juju-core[._-]v?(\d+(?:\.\d+)+)\.ti)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fba592503fe1cd8d0506916afe3c4494fca4ae83dc66f8ed920190e64a606d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01444eab226cb64ff591670af41851272f158b6aa088653dfbacfac01f52ba81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce5919d559c873968cd46a518d21c4d6c23852c345ea4f269614784d3135912"
    sha256 cellar: :any_skip_relocation, sonoma:         "290f949432a3d345a1b1d6fc59f2c60cd21b7d7903dc237869cee0342afb1928"
    sha256 cellar: :any_skip_relocation, ventura:        "6ebc12659d8665111182c82386db6bf2b5d0ab249f36a7f455cdc7613529f98c"
    sha256 cellar: :any_skip_relocation, monterey:       "a76f7c86a4346ee283a57d2eb032dd3d4ab8201e51782cf3831807b6606fcb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caeb03353f162009045b03dd9f2c3979b4f4e57643752798418d091afc377ae8"
  end

  depends_on "go" => :build

  def install
    cd "srcgithub.comjujujuju" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdjuju"
      system "go", "build", *std_go_args(output: bin"juju-metadata", ldflags: "-s -w"), ".cmdpluginsjuju-metadata"
      bash_completion.install "etcbash_completion.djuju"
    end
  end

  test do
    system "#{bin}juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}juju-metadata list-images 2>&1", 2)
  end
end