class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags5.4.0.tar.gz"
  sha256 "603b439b470c4112d650d4b6b5a21ee5250e553e85c753f5221b43d053c2bad7"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4719de47efbdf6439926ea52646b0f38421a8a6ce3f27106ada0f72a09e11078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf5c168118d78d3625cf8dbdf31edecbd10b31f4d9ff31f3fe3621c05efcfbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b537cdb1539fbe620c5fc4cfbf2c227f39c17c51922e6644537baeb15d5deb97"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f097bd13a24761be2f84ed7026ebbbcc805424cb9aebb7e696291e53c77772"
    sha256 cellar: :any_skip_relocation, ventura:       "8610dc206a32390fd19bc90c3e9a6a250fce697cdb1cff77893623ee196ff726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2200667974dc1ebc3571c42cbb347a99c8b6b595f11c81c011be9b5a4f81fae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e411500e12be624d6180ff03021245aba5b083007c7c6488608e92010583597e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionstspin.bash" => "tspin"
    fish_completion.install "completionstspin.fish"
    zsh_completion.install "completionstspin.zsh" => "_tspin"
    man1.install "mantspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tspin --version")

    (testpath"test.log").write("test\n")
    system bin"tspin", "test.log"
  end
end