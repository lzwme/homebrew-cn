class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.63.6.3+downloadjuju-core_3.6.3.tar.gz"
  sha256 "f45e998dd1fe407ca6a54c68e6555acc5c04e69d393293bd46dbf3da97629a80"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f1c5460cf42c49d82e875dd2e4c4b2771edf8b26567aa84a874bac2810cf588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f61fc3a41defb1d7a0d6adc34f98e11b51e56d70a4163fe97ccd6dfd7811c58f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9698e0d4a4108534c529ae4e8a427e976a45ece22784a93859a65acb4e38487a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d651019de01b7a4139becb5cf3d8e2a35c6c80a8453ada362c49c5fc86d2e6"
    sha256 cellar: :any_skip_relocation, ventura:       "b1e997da3861777b2d5b7eeeee48aa3333dd4c2dc1a92132b938ecc27cc2ffae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd0f4207ce76cbca4f715d404c650b92c0ed43930d42bdbd0ed874eca0d5c88"
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