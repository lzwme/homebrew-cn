class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.32.0.tar.gz"
  sha256 "7c3522d2fae123deebea592cb0ce2a8be65b145efadce8b0965669a4337f8494"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa65a385d8d0c5cb88c7b82b137dd38fc5e57bf89fcf0b3b884ec35132894bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71ee08f68f4a6da5bed3ee74634ba93108462c912119a723b4001b803b33d942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a3447df5fd0157a1ba10285847726dff1eb87c96b380627296fbd00f8943e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfc03d1309baef29d2a6ba0ccc8a978b8e2856eb377b0816e960516ae02a7f5e"
    sha256 cellar: :any_skip_relocation, ventura:        "59efa95c1fe670b04f29a3eeaf54ce874844f064cfcb80ca798aed485dd467cf"
    sha256 cellar: :any_skip_relocation, monterey:       "85417599d1fac80e32f5946220267174c9c69529eee1d50c6c7e7e843f7b2541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37fd529b7caa7ce62a04ac4f6336cc06e6205b91892dc5fdd4f5368157bcd9f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"just", "--completions")
    (man1"just.1").write Utils.safe_popen_read(bin"just", "--man")
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}just --version")
  end
end