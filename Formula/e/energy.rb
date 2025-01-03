class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https:energye.github.io"
  url "https:github.comenergyeenergyarchiverefstagsv2.5.2.tar.gz"
  sha256 "693ab9fa18633eb7e35089588eb58eb49c9db7886ef175b534aa1ab26862a57c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a3ef92e474f148f82fb68588f66e38a8143676418d088d2c384f805fb504542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a3ef92e474f148f82fb68588f66e38a8143676418d088d2c384f805fb504542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a3ef92e474f148f82fb68588f66e38a8143676418d088d2c384f805fb504542"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c1e12e3b2587a9f3dea0f0f7c8ba6bbf2a01cfa6ac3553af9d649088a6a87f6"
    sha256 cellar: :any_skip_relocation, ventura:       "0c1e12e3b2587a9f3dea0f0f7c8ba6bbf2a01cfa6ac3553af9d649088a6a87f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c292e6532b34c19af3f3dbd0dbd1f8f1d162877647be8de3d10a2a7e1505e2ed"
  end

  depends_on "go" => :build

  def install
    cd "cmdenergy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}energy cli -v")
    assert_match "CLI Current: v#{version}", output
    assert_match "CLI Latest : v#{version}", output

    assert_match "https:energy.yanghy.cn", shell_output("#{bin}energy env")
  end
end