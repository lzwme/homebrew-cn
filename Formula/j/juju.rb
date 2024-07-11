class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.53.5.2+downloadjuju-core_3.5.2.tar.gz"
  sha256 "c20dfa9a455ba10aa8b0273076d9c0c882fa8c5add86ca9b1d37a4816e73e3f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "decd88c58882123093ec859d6f92a5faaa7443c67aacfa814797dff9361107b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1ce8bdd99191d274076e356916fc419d4d31f6d86489529caa65bc2a0b5f238"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb5e89a3acd481ae82f7c863213b65891b2fce3c336e1d0010ade66ce1e4a67"
    sha256 cellar: :any_skip_relocation, sonoma:         "6127cc31318c764ea031451cddb6939f5fad96fee8aeec1a25a9da59dcd57727"
    sha256 cellar: :any_skip_relocation, ventura:        "3bdb31ea8351da47dcfee5cfd65c60a63c6168354bd92c12deec1750b975d36b"
    sha256 cellar: :any_skip_relocation, monterey:       "e52b90c96d6f6351a04f8643bef0957841a18e2d450e5104b541f7e2dcb6f7ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbbaca4501c5e9b1372d1b9f30e80a6142a3a9f79b64093555970811c4917fc0"
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