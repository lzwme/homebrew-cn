class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https:github.comedoardotttfavirecon"
  url "https:github.comedoardotttfavireconarchiverefstagsv0.0.6.tar.gz"
  sha256 "d06055563247fa50b0cb6bc3523e468bb41e3a6c3de444e3a304dc681ecec851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5cd6734be20dd0846ef5b052e681ab9eb41a5fd87e1dddc1abf7e044e3df7f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33f1db7d620228b80f0c38be9be0e84139d7e3e70da414fba697df951ea7947d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed18715d24c1cd12bb44fac53b37894662da42cc7b2d62a91563af29b508905"
    sha256 cellar: :any_skip_relocation, sonoma:         "c05f355cacd377614ae2a97a5c8d44b0d710a886e8622cd402c2e54a4680644f"
    sha256 cellar: :any_skip_relocation, ventura:        "966a3083c79c04160637faffe57f2b8458b302557f834e01fbee04174aadd389"
    sha256 cellar: :any_skip_relocation, monterey:       "710a96804601923bb1de16b8a59821ec82b810edb9ba71fd98bf26d3e1a56e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fad985b008a1c4eb5ab4e291112cddefcf88130dad8d30661170ad800e4f7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdfavirecon"
  end

  test do
    output = shell_output("#{bin}favirecon -u https:www.github.com")
    assert_match "[GitHub] https:www.github.comfavicon.ico", output
  end
end