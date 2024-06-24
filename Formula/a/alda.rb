class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https:alda.io"
  url "https:github.comalda-langaldaarchiverefstagsrelease-2.3.0.tar.gz"
  sha256 "4643df09e5bb28232cc30a49a2b995bd40550342067ed25df25ff757e7ac8be1"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3672a5f6b51f58769f0a6234b0c2047e54a8798f0bd79454ca088e17f6a61b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0802715ed501f7f001eab88559cd18014e91d1ea1aab3cc3524ed92e52db3929"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de693af4d866830b16baecad8440257d1bae5653cb7c19aeb38636dde58e4b2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b5cfbf98eac5f30226f6694c02b6d6bc64bc05a0a248364ced3f77e453f25c0"
    sha256 cellar: :any_skip_relocation, ventura:        "1e7b4808223d45b20b369cb47c09fb58c1d71a7f8490ef52513b75aee91d6774"
    sha256 cellar: :any_skip_relocation, monterey:       "f02001a8df4df7bc67f09f0fcf171a7a85cbf4182c19a71201d2fc237eae90fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e4c5180fa45c0c8c5e5676a8fdb758d3a7714c2d0582d405e1409befbfe693"
  end

  depends_on "go" => :build
  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "buildlibsalda-player-fat.jar"
      bin.write_jar_script libexec"alda-player-fat.jar", "alda-player"
    end
  end

  test do
    (testpath"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}alda parse -f hello.alda 2>devnull"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end