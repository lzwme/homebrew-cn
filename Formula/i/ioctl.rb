class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.2.0.tar.gz"
  sha256 "d60663eabd355e8430baa0c43a7be8f5fd5b8c6daec5a922a1db70b446d4e671"
  license "Apache-2.0"
  head "https:github.comiotexprojectiotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5db80341a9e6cc410058100af41ba10c04fd7ffee2d30eff4faa905dba075d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55004ead094d3bad87c3d531d519184d884af65f29d8566bd438043ab76e0350"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "892d380c3f4290a77ef249e701a6297213a8028dbd643bd941b04d254ec1d40d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb8ac454eeb5affe6ba3ae93e18878e3c0f9a37bd446752521b1a3c8e9b9102"
    sha256 cellar: :any_skip_relocation, ventura:       "6a2bfcaa40c3b30aa799caa31243149fa93763a9c6ca0587bf8959b4ced55e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c275113d89096c7155e68807f68daf30fd2bb995b901a96126b1e216aa1f86df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8bdb7582549e880948ceb747c8d53125340051bfd023d951f5c5aaa8c5c06c8"
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