class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.0.6.tar.gz"
  sha256 "e3b331ca1420521c32a7e263a9c25f0bace351260bdce91df3ef91c99149d254"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bbace2eec7303cb8b224a37d395cd5acad9f11ed807c4ca49025d14726ec150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3f6bfa399d5c692f15074036b45d6312c926784ff0ddda9a7e3a4ea52bbfeb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7178b224531c70aa89fcc7053f502b457786973233edeb53fe266f3ea09d5eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd806b695b8c46f0a8b0100d3887dd0e55a95d65ad497c58915cfd02b3068e7"
    sha256 cellar: :any_skip_relocation, ventura:       "6a1d5fdefd7edf2b9dad821d6474d19f6a07c4783b1830fe034266a861db5a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4152362e68415a10c69cf56b531dc0bf13c973462e6dd3d4b019b309b1bffba"
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