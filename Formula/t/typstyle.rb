class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.11.24.tar.gz"
  sha256 "880e696d886acbdccee2200d75e600e621e4000be2f74725108627fe2e226530"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b89626b4f49a96136adfba49a21870b6b9acc06058c7c32201a9ba59aa111f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7f2596023a4111923cd8bbc5968c9d60c7a8447e061345b5f3d7396e65f1d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b618197966f135e7d1c171b4ed91dd5db5b35f952fff6ec5c0e7183c47b1555"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddbd70ad24856f8649dc2fe59d23a1122bfcd626fdd430c5c70cacbc32762308"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d109a7c72b6deda7cd538d6c6215df57feab6f4a2981b35ffe09555593cc7e"
    sha256 cellar: :any_skip_relocation, monterey:       "ee7a13477d742bbb38f248a766db7848abc2db6116f25c6937497e9a2860bae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554098bcb26788cdaeccb813912013093549b487386c248fb7515c6372886ebc"
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