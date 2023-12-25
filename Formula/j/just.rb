class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.18.1.tar.gz"
  sha256 "a726e49c5773ad00881033f49a2f2bb1b591fe7f578f8780af49ed0cccec3e5d"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed22dd8caab94c8d1ef786887d50f78744ca29e9051cab41fd890c84893f2342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3000c35af3e2598a144022de7837371c7c18ff7a408bdb79155f61d80f8054da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa04bc23cce1b37b660b2573213525e765b2629679f4bbba7b02d1aa4b0e4021"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ae061dd0013bcae3bc088cdd9599f34ddde5d4f31c25a259ab6cb19e5a5a2ec"
    sha256 cellar: :any_skip_relocation, ventura:        "08ce1859d46b0277cc767102679e0821090c710fdef7d61925852b55d1db025c"
    sha256 cellar: :any_skip_relocation, monterey:       "417e775a5ee28fd99d67814d8a1ff396b3aa458320fe4a47284acd37ba1815d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59375cbcca5c076a63f491f788dd3fd136c3a9986ff5326098d874a4ed5068c7"
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