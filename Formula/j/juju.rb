class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.63.6.7+downloadjuju-core_3.6.7.tar.gz"
  sha256 "456395d2974c88a69731f3f1af20a8a989b9b512e664bd0064dea1b9c02d879b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4eda0b171942806a3e54735198c20854545da8672b1abf11fedc9ab638ede6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbf9659c236d4ba39920b5a908ea8c2740fce89ce860f2ce759f564bcfcb55db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47e7fd1613a59a486316d7198cadf543a3df15e1135b71ce44a764858689257d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3e26756fdf4de82359fef43697914b6ee5f4864b2b27dbe6b0dc7cdf23f053"
    sha256 cellar: :any_skip_relocation, ventura:       "4d8c5ac8b1e1034e92d78fbf9c9dc1c4dfa07451b812580ef8536ebab4f961c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b687a7b72a486b5112528836b33ec276a9ba1f198c1041fc330d3ab3b53573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484d8eb64c76a1805e5f822910aa586ba207168ed74f50aa2812b2d3efd7c03e"
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
    system bin"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}juju-metadata list-images 2>&1", 2)
  end
end