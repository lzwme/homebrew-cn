class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.22.0.tar.gz"
  sha256 "d43bcc64fcc5ceeee40a68268848ee64a30fdd24533d0c996df3cfbb1415a224"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7a7651cd00f8c8c1fdb1c745a925a5bd37c0fadc2430f8401a766d2a470d276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a740a43783af3dc1a6a45cbf0c7d5d69aa1b370f785084b1e13ae8c2ccf9b836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad6fddde1e3517d433b21ce415ccc84abd5c594c790994e1915e94b8ca2fcd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aa2e86bf97d41fca90d624a0b1449ddfaed833e19e92f94876d19f185362058"
    sha256 cellar: :any_skip_relocation, ventura:        "ba5fe529d7c166766963c63130a9e4deec8fbab7cced681c38e9d1911fe3f668"
    sha256 cellar: :any_skip_relocation, monterey:       "977904e320831d84556b122a91204db9bc765eae62f3122963f1e4e917e18aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ab408dbe34e2a1ea8e2e0ee8e10d50b4ad7da81586d72841d42f372eeaf4e26"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "manjust.1"
    bash_completion.install "completionsjust.bash" => "just"
    fish_completion.install "completionsjust.fish"
    zsh_completion.install "completionsjust.zsh" => "_just"
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?
  end
end