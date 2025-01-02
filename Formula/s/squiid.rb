class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.2.0/squiid-1.2.0.tar.gz"
  sha256 "01f6142c986ce744ea7df86da17d43b593d56c8b843e6f502b0327ef43e3fcb8"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97ee3c9aefa92849eb2035247140e9251bcd80fced19aa4d931c7d9d9ebf142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba82ad3dbae6891479c525d56d8649523b9c00fffd24ea5214572648f36997a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1420e93bb7dc4623e3380a45f21447d3401cf7e816abed31ac53e2ebc311c26b"
    sha256 cellar: :any_skip_relocation, sonoma:        "df68d316d895db0785b6f73f3d96c28ef4288e3acaf04d1dffc26a3df7f03fc5"
    sha256 cellar: :any_skip_relocation, ventura:       "f7a31e140257d45be2bd4b328caaa949d58f2c686a971c36e2d3ce15f16952c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "846b23e093867823f602a56c6c1367481dba85c0c851366e20370b2d1a762e6e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # squiid is a TUI app
    assert_match version.to_s, shell_output("#{bin}/squiid --version")
  end
end