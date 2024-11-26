class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.4.tar.gz"
  sha256 "c25a89e15d3c3b5cd4e1e0a5c416796fc5408f8c47508e36b2c3676486a23d4a"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20e9b1d9026c2011395fa49d4e835f66674f1c9547b9f8fe13d67d3dec556d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ed585ff47dd30a2f3720467a60ba579a7faa7a7e0b3190373746bf435b0206b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5b30d69c0fd9dd937c305f35df804e3288b3674b5796d13c4d09a4ebdf1545a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c814f6bd6c1d1c6109f0eb30328e5d7202e59e999fc8d4c9adb0da5aace1c928"
    sha256 cellar: :any_skip_relocation, ventura:       "2750a35d0df4652d92bd4edef53694c97b429ce124a2dbd26f3823e71719e13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a53858c72fe8010529ca2f665690578a6f336e4d98d8b85ceb2a4ce453c8278"
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