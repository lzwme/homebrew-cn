class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https:github.comchipsenkbeilchoose"
  url "https:github.comchipsenkbeilchoosearchiverefstags1.4.0.tar.gz"
  sha256 "b114c7f8901d37bc4deaed6e33b49859b8e41b38b9c938ab8b24db91faaa80c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20867b598ec25cb0522055a4ad6dd0b2e95e1743700cae1ab38f24f6cee0bc86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90ae5e48fb6007dc0fd3faca5a110abdfa75835f2efcffe0a9791aa5180bcc40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3c27461b8bc6a4fb31bba781dd9d0353193d74d3dafe7eddb66ada4cde6ebfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe52db719853a7cf77bddb44eed56554e25b60187db19715fb5776a5b326cfb6"
    sha256 cellar: :any_skip_relocation, ventura:       "0fe9217f7fad725214e481c13d15868731ae2059da8872e57ec34dd9f2687918"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build", "clean"
    xcodebuild "-arch", Hardware::CPU.arch, "SDKROOT=", "SYMROOT=build", "-configuration", "Release", "build"
    bin.install "buildReleasechoose"
  end

  test do
    system bin"choose", "-h"
  end
end