class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https:github.commrjackwillshavn"
  url "https:github.commrjackwillshavnarchiverefstagsv0.2.0.tar.gz"
  sha256 "1e1f8706c653e92f8628fe6e7d56b63a64fdbbad7fae90fceb084171d69c03b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d848eed186b8fd627c8940b523e124e81a867a3066ca29eb61328a5d61800c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "621202376b0844a520b53304095c78fb4e0cc76f0be5f5c0aec2e06631dcdf57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc4173df433d270867847c18f2646314df969222a8be87ac120804fed41370df"
    sha256 cellar: :any_skip_relocation, sonoma:        "031e08eae31c5c9bfe147a2e03affd1baaca11efe46d91345703676d085e64eb"
    sha256 cellar: :any_skip_relocation, ventura:       "e70082949c1a15b512a2027ab3b9435ed00a2b961107fac9d59e63202eea8fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f62787e7857f78386c1713bb1d9be69862ce0d6bd988d984c9ce6a28ffed1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1723df8d6e09716b7f84d1316ab5c00edf87e1f11346956afc7569788a910629"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}havn --version")
  end
end