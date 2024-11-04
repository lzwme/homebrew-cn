class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.1.tar.gz"
  sha256 "68138962a660bec25cfa81503753505a02dc6b14f7b1b7b587c8cd521e96f8e0"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ff234e84ab0ec10ccff0d0fc1d1391309bee331a3588a189227125350a5a4cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096179ee91c7958a85d328ecefe3fd59643b14d27dfc7180c3d6df2fb2097f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1146b362990231f368f443d6c4135d860817b9378ab29c4f2e2fac15fcd99b26"
    sha256 cellar: :any_skip_relocation, sonoma:        "be57f5c74911b01a89b5c795078d03fc81b02a01835f0a52c0797e84b7a60289"
    sha256 cellar: :any_skip_relocation, ventura:       "7ae8107449944ace38a706408b16ef1fa065ce2d0ab920babea2515781a105ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14266c28d68d15afc9affdafe4eacfedae6f839fd630c8ecf297f27bec0b3b4"
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