class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.23.0.tar.gz"
  sha256 "d0b04dc2e33628b56fa54207f7bcbd5b7a052514be50b16a70c8d6961dc232f0"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7168031b1dc871c483b99113f7c60675d9be26290093248a6135b988f2b66858"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "189605a299989bec97842941d1737ce4bf1cc5d3ae19be6a3caf03301ccd8029"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6788e2b409ee7b51778b773b15cc119a20279e317e56b31ea1e0a8586b9ebd6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "005039ecc032df2e1e7a9b8e1a441682b2b30714a911ff23f1ddd0ac04b75304"
    sha256 cellar: :any_skip_relocation, ventura:        "29afb262d8b7c34a3df5fbc9194c0980ec7c88b456adec89a9d52b6f10cb7973"
    sha256 cellar: :any_skip_relocation, monterey:       "74ca076e3130b64628c7d6cea623bf4cbd44b1781ad06dc8e20afaea7eef04a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56a6b2edf2b22b62c132cef1a2a39406c856a41bd6348f17ef0ad6512876eeb"
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