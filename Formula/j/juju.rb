class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.63.6.0+downloadjuju-core_3.6.0.tar.gz"
  sha256 "624129055f193ac8a769e5b11747bd94f18dbb415ea4ed15a13785f3b581f39f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed96e36be607ca57d879a6083f2474d976806dfafaeb755fea74a4937b6de789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad63d61758d74246d2f0d5d9e9a189ed8c24aa44529a1a136c2a98a383b88122"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9976bd2183ad42f73bc208a897aa48a5b3c77abf32b872d6b394a91158d942d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9326c4337bfbd67a22004c3adb63ba297373099cb0514ad3072f42a68c03d51f"
    sha256 cellar: :any_skip_relocation, ventura:       "c5ce290aacc734961474f38fe5c36e81410f2f1bfd02d875731cf20a80afd24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891bcc97048e0562ce4cbe01d4ec5e338457ffebd2fba78ddf939232917c7406"
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