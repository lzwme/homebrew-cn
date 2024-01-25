class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.33.3.1+downloadjuju-core_3.3.1.tar.gz"
  sha256 "5c42ddc572bdf7b3191a522171a141d0e022df05c05001c5fe08290fc073ce92"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54cfc458a36e9ed0a4f2b583e2208b6fd857b963c2c6b67a35d632611e3da7b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb825bd0d7708263bba3fab2b87d7ecb33584792f05830040d2032f6e97ea77f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9653d02afb7a2d8e06342f03441f7e6fe77ac8ac639e7379744af1acc7b0085"
    sha256 cellar: :any_skip_relocation, sonoma:         "0093af6c2033376f11096d600903f9220686d74efac2958558bbfee5ced0d13c"
    sha256 cellar: :any_skip_relocation, ventura:        "504e6a0ca6640a4ebdce62d49e0325e07898de41e07d2befb058f959ccd3926b"
    sha256 cellar: :any_skip_relocation, monterey:       "b15eee393f22ab0631d8cc635ad3e32a385f2cadfd6bc7ae47c1c50b33620bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30abc7ecedd4f88549b32e9ddc0f218de5b4eed30b9a88d0bb441f10011a8ea8"
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