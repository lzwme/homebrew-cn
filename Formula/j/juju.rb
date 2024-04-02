class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.43.4.1+downloadjuju-core_3.4.1.tar.gz"
  sha256 "0baaf235b8023f3ce6c56f2207aae39472c7d55621708108ca630fe62e14f84c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12ae98cd51b6a501daa92c9efc65e5bec5442d7644db316ca28b035b5f5a1139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1401a648eb80f1c9884539c185093b34df30d3187a12c2a10247ca86e9f2562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c08cea28d23e89bbe2bfebc54ad8833b164f2907b48213ae3832fd70a0ca263"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6fca31dc0ba52cf1417349a55a26ea6ab9ffae60b7583d9d999aab8be4a6649"
    sha256 cellar: :any_skip_relocation, ventura:        "f6facb9271e914ccfdd73286d7a2dbf9f22259e1e0a0f5dee7a591942da8dfcf"
    sha256 cellar: :any_skip_relocation, monterey:       "4998f9aa622df1aab84bca5facddd7b6f122a3acb7c03db9048b6ac5cc71b251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "777d53f4963d9258e058e0ecd8735733762a88ea3545484c16feb4912104104b"
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