class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.17.0.tar.gz"
  sha256 "1306a4906a3ee2013766e9c580bc0da3768ffe99ca7bfc33229a6ddb856c5fa5"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d0d9fc7a21b5983d7fc1c0a7f5480bd56371ab03aaf63ec04eb4824e567cf0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a10b12df72ccee3299e484e349805f6f38e9bb01dd5dbab8568f83bfe5e487"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9658058e6a64d7d3a03c153f0c46a55b376766cb9aa8bd03e2a4349a479d67b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f117a997533103869d532b890e03c3aa0435d40a3f5fad00c8c69e110d4c6d0"
    sha256 cellar: :any_skip_relocation, ventura:        "0db2247f0940bc5900bbf3df683568b2251dbb28a8a47cc7e72a6a16b0d0692d"
    sha256 cellar: :any_skip_relocation, monterey:       "ad91221efd610670f640bb6703e4017ae5b3ce6e68f24e4dda4c61d95d0c4f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79828a1157185d4073ba84a73d43afb6d363e6e5f1a54bfe4a2a0e57811f000e"
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