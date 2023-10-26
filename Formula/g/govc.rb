class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://ghproxy.com/https://github.com/vmware/govmomi/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "541d0409f8eab292eff34004496846b8df83215d021d979495c8c9019c5288d7"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77be92ceddfc62f2bab8866ee6a61bde65110b05e2250fd99a834e8453ae60e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6837dac3544706b1e8eeaaa12028193f90a596f9f50550d192a2094aaa4df00c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da4ad6fdaecb7c1631474f515d79eda8ed052160b3d02d0e1b905de5c2c0854"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3d48648110577a2ad354e3a59aa3955fec4219e9c79ad822c76f0f80d808ce4"
    sha256 cellar: :any_skip_relocation, ventura:        "dd325ba960b62686294f1bc184c59af605da83e8d609b3e999977b6a9808ecf6"
    sha256 cellar: :any_skip_relocation, monterey:       "3f82d81f4ae7bf034ab80672ec907ddff119bb4648b9cfdb295292023a44c76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0668e6fdc984184c2f4eb5287ac30f7449ae59fb4b0626a77998df26aa37e944"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end