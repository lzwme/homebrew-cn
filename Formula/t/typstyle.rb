class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.2.tar.gz"
  sha256 "c80f4b3575d81080c3d733d188c84c1bc8c23194ec36477d8c290401eac6276d"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ec899b41c9dfe56fe0719c369cf9a13475d80e1709ee5d327bfedef34883ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055afbdd186dbeff7004a7741d1d156578cc7d4fea6c3aa2018b559854f45f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d03d423640e2d0ce5586234e36912ed283b1bda0cf6877fb67ce8dec146d9e2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "056b85e90e716f983e0cc0cc8461c6a9221baae1fcd543a6c12d3acb7cd17b45"
    sha256 cellar: :any_skip_relocation, ventura:       "cd44266e0fc7f29c61f762cbf50b2a4fba5db69a499f4697b266f2753394c101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffdc0f8574fca3084512f5f6ed67475316d1df4e6b1081a0334cd7331c9ca1d"
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