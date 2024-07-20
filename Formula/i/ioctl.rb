class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.0.1.tar.gz"
  sha256 "d6a9c0c399916261efe977c33de7f29cef8a94f7438293e9c079bd9dbcfdac03"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c94509fde8588a6a28387ac42b60cc78c7528ef0885c41e26146d42d39b39ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03aae7901846a10333efd6e134227a586438f75d9f4ad71d220f0e0c71fe887c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ffe8e5f2021dbeaf2a414818c44580d79a68970507ff6d67e03fbe234e9a996"
    sha256 cellar: :any_skip_relocation, sonoma:         "969e9da343aa7d130464e25ee5041720c7d03e917001b0344cd58740585d956f"
    sha256 cellar: :any_skip_relocation, ventura:        "a57d210f9177c4f7a2570da6fb182e3bbe868dffe32ff45676b784217d911239"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebc2ed64ad71725004837c60c507a52342a18b1294d0dcfd1a6009cfcdee2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fabd311c23b9c225ba599e94a066fac43379898a26fb7f9022f361d3f97beb2c"
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