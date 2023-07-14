class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://ghproxy.com/https://github.com/ucloud/ucloud-cli/archive/v0.1.43.tar.gz"
  sha256 "6757006df4effe3d2adcc85d81f77bf6dec37e7853fe133eb3ad3af959c1de8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20fc6766cc45c540ab1729b358cea82df93a490caa9405d74fef1d5623f72c95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d7145a34e543054b2d5bf338cc3e7095d39141d05541bb76209e52b26ba39d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90fda80cc1e1111695ec2a25cd2571c5ee5b7a5f20f5559467a6276c88234430"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea2f4f888889b64ed16784c91965bc9cc1394c5f8dda22f2154bc166037f02a"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe2e5d6ebbf9088d63a87fe1be103c367961cc48f634075d59b6a4d30e3d0cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "15a1d594d31f027e135528ebb2a2170418e37c64c3f23e051dd589095c4fc376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a0c6e0f00d796bb1efa3b66388d4a8108b733fe1047cc17aea900499cde4d0"
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end