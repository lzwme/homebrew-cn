class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.33.0.tar.gz"
  sha256 "0be2fe1116b92249ec8a25a4c14e0308b8a99b4286464ede1483cf149c19d1f5"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "441db7fc1e78d63403e94f697cc0632244ddfa0e1a404495f68b306fe8e97565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c147614671fa363882a4f6686e633d32883abf68032862687229c24a5d432b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e888ec46ea1bf4311535b6b7c58181fc8bc3b8c12c499ff789e2bbf9aac00caa"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cefca95068269ca10a2b4bc967d117689736d55bef502807c3c13f8a47945cf"
    sha256 cellar: :any_skip_relocation, ventura:        "2a94186e2266488ba017602b5b0dc00646f50a5d6e230c9f76eae0d83d00f32e"
    sha256 cellar: :any_skip_relocation, monterey:       "44844984314e22df36088ee5a86996cd90e20479584f5abd88b3c561d5318c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062a977a250c2db28fff58aae731d92060a869506ec22587d0b5c98e317e633b"
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