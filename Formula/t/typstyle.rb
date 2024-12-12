class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.10.tar.gz"
  sha256 "35d4b9b3f1bee7c2d4fd1604627978874cba7c7c76078621fb0c605dde512a43"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74acdee5b167e0e86b340e440a4ab682caa58dd74dd375b70b37437180d7daf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e56eeb27cc4f9ce178cd1ade10919b65bfbfd68de71744065af96b169453dca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54d0ecad39364fcd152ab49ae3a42bdf49fa1560331aa309d138b9b0a74a9f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "b111740ca047d1cf87e56ff76f7959fe99c93551421052bfc503d552046241b8"
    sha256 cellar: :any_skip_relocation, ventura:       "040a6c604dc47f711ec09a0e054fac1bf3f33472682e76d7261b2a0cb4dadb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b70128b43a59e188546fd7bb58aee1c62e708d715981cea823f7da2632122a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end