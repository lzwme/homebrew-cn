class Ad < Formula
  desc "Adaptable text editor inspired by vi, kakoune, and acme"
  homepage "https:github.comsminezad"
  url "https:github.comsminezadarchiverefstags0.2.0.tar.gz"
  sha256 "7bb4aba27b34e0eb0814bfa14c3b6d87a0c411e8ae12de2c62f76f23ab358a70"
  license "MIT"
  head "https:github.comsminezad.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4073858a0c04f536678cbb56f9ec0bb977171eef6a2da094fd99de1a3816ebd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5455f22db006e3f64867267e524136bb09b953115feb9ec42cac25367baf952a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11ebf6ca0cbe9c8709219c4bdd5cc9de7fe25d6d3107f9c1f7f48cfde139ee23"
    sha256 cellar: :any_skip_relocation, sonoma:        "8617459064ff349b4eef8ed257f686fc5009630ad384ca6af0c1087b968776df"
    sha256 cellar: :any_skip_relocation, ventura:       "e7884a0711ef9f5adef027ed57dcef814cdecb664135ad37ade1382878864d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9964c87ac0c1d8475520eb52560159a1f504e3a4e4a42894e3a7447cfd5127"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    # remove `doc_prefix` with next release
    doc_prefix = build.head? ? "docs" : "doc"
    man.install buildpath"#{doc_prefix}manad.1"
  end

  test do
    # ad is a gui application
    assert_match "ad v#{version}", shell_output("#{bin}ad --version").strip

    # test scripts
    (testpath"test.txt").write <<~TXT
      Hello, World!
      Goodbye, World!
      hello, John!
      Hi, Alex!
    TXT

    (testpath"hello.ad").write <<~AD
      ,
      x[Hh]ello, (.*)!
      p$1\n
    AD

    assert_match "World\nJohn\n", shell_output("#{bin}ad -f #{testpath}hello.ad #{testpath}test.txt")
  end
end