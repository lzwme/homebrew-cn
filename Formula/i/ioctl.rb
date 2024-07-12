class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.0.0.tar.gz"
  sha256 "a9598c053a2ab2a9123a8634ed56d108513a42512607e08196a8796ed0b9f674"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fa21b111a563749089da9e2de5bdebac502327001f107c74583a54f1ddf87a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbf5eb9c9959abf70fcdd3f2a6af143f6850fe69c174945647dbc174e726bf19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52276bf5bb4cf650322e8e7922361679ce8be3154d4174a11f60cae44d90d1d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "165589c9b359b1d69cc34e90135e61d29e0961f4981f3d75e52542262ff4812a"
    sha256 cellar: :any_skip_relocation, ventura:        "14dfbbf76e55b874202a829a365995ce58504daaaae2bfcaae5d838a71778760"
    sha256 cellar: :any_skip_relocation, monterey:       "53cc703b991bc5cdea0126c2f5b21a1aefee846117c7e59e1ed5f579e6286c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da423d4982e79875c6d7708633905929e04004684aebbf30909ca7187ac22bc2"
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