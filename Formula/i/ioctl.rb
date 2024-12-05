class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.1.0.tar.gz"
  sha256 "43e12b18ba982d3c883930fd70fa4ab314d4cd37067c40302f1ffbdff9523df1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329ea429487ea092421067610395f56fd8385378da6391102195c819eb15c7b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0abe9579b70d3d86ccaf1c86999895129375d2f76707fa48ff118ff14c4d91b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ab710a1c5272ed5ccbfcce2aeec3fbc65dd986e2ca08971387d4e432a91105f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4838b1d0a16f9b9d7ed6cf643de887cf69ac3298027e7437271b01320da6e149"
    sha256 cellar: :any_skip_relocation, ventura:       "ee1c054b26bab8978d206c325d053c4b00f35e9254af9d42d76ef09232f4efee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336389830b179fafd3ac5417a13e8732518b8133747ffaa329b6bfaf54a70ccf"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "binioctl"
  end

  test do
    output = shell_output "#{bin}ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end