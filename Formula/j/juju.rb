class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.63.6.1+downloadjuju-core_3.6.1.tar.gz"
  sha256 "11b036d7f96fac0e403fcff673b9cf7ab6dfbce636a976d7006b413114490dde"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7182dc9f48bbaae9f1c40c851a91587a8a401ce94b4590ec5f0d11d940091a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a33fb2f15c6911bb33368f5b62964f42b2da7ba6710ca01907e3d82befb4d880"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9504cc4d2be16033162abbe553dec377437233a6d560fb789faaa377c98fbcfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8a56fe91b0e7c4193dc8ed13a7d28ec589c3ea07e04e4cc04682272734ae2f"
    sha256 cellar: :any_skip_relocation, ventura:       "8e4eda0121c5ca91fcb84462b89b25caa7f85d84d1d85983cd4ce6aa808e2712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef2a159cbaa7dd44bb537662c2158afde2b166b294915214f5fba45b4dbb4386"
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