class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https:github.comzk-orgzk"
  url "https:github.comzk-orgzkarchiverefstagsv0.14.1.tar.gz"
  sha256 "563331e1f5a03b4dd3a4ff642cc205cc7b6c3c350c98f627a3273067e7ec234c"
  license "GPL-3.0-only"
  revision 2
  head "https:github.comzk-orgzk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "664a5847ead175c15e4707b30e8ad541d4d6439adcb5d4e796383617ca4bef04"
    sha256 cellar: :any,                 arm64_sonoma:  "c78bc5f19eb2488f395915490a9ed166de92234f1b9b98f3f293115dac408914"
    sha256 cellar: :any,                 arm64_ventura: "1bdf44805c90f588466e12d80f718b28c9580229f49b510f3b29e950dde5f8c4"
    sha256 cellar: :any,                 sonoma:        "8d0804f647ededf61fb6ac9852ebc2fbea7300ef6e0503e0acfc51972f86a111"
    sha256 cellar: :any,                 ventura:       "0ed9d6a9cf2fef25819e3fb86533577893babab15cf5f4138b426392017be2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e944b48af4d8040b7f3b14fbfb823d19c3aed8259ecd9fb6952523eaf2f364c"
  end

  depends_on "go" => :build

  depends_on "icu4c@76"
  uses_from_macos "sqlite"

  def install
    ldflags = "-X=main.Version=#{version} -X=main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5,icu"
  end

  test do
    system bin"zk", "init", "--no-input"
    system bin"zk", "index", "--no-input"
    (testpath"testnote.md").write "note content"
    (testpath"anothernote.md").write "todolist"

    output = pipe_output("#{bin}zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end