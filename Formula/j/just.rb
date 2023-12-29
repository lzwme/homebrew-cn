class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.19.0.tar.gz"
  sha256 "8373f68d39b048828d10887dfc3bc13423ed34a6d672f826a36b40a0bd07380f"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdd27cba2974ee71396d75f80b01e624d4e68091e669f296c6566ae1fc36c112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a75e0208992f3d2c70745096ae1ebd9acaabb49786bcc349e40d7271fcac2fcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54692143508e3a243af7e598fa26a43a137c85e39fedcd72d8889b45b8990451"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e4830b1c405e5c0912b9be428af8a796c8c7786ed7811a04bc82c222951e99b"
    sha256 cellar: :any_skip_relocation, ventura:        "e4dfd345eb59b934ba2c4e75be2ffe28735237391a99f82bb01c2e8502a0b5ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb91367fa9a05bdb8e3b5f47dc95b95ef4f18de3f2ff9d1d038cf5083799f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643d86052b5a7ca2a44989db451d9d1c6618d11512480027178cd3318aa9a095"
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