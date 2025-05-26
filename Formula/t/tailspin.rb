class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags5.4.3.tar.gz"
  sha256 "f024fc4cbfd9217014912ed9a3d8636be6bd587f473b97ff2bd729eb2227729c"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbec07f6dc147940203c1c46378cc16ef6eb903f40efb10aea152fcfdc6e1bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd0f610dc3b7caaa3752cb2301a24ea4a7ec2cb0bdd6bed2b7be9c389fac5c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03154f2ec27debc92ea2b2dd1fb4d4d11d9aa09fbc872240b2a483675ab21cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5502df8b1d5ec79aa1f7865cc67373a2d06f4a3cb46e7567a0a0c5cde447581f"
    sha256 cellar: :any_skip_relocation, ventura:       "3fe0dadec03e7d8bbecb3306baf55673e469aa12df7687e0df509b5b16db4c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633f7dc5864cf7f38215b06e81f7763ddd56291f7323485550b6162da4ef1ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34eb4902f36850fe4ddba31c86086cae9336b35a664f47c178945116a2c72c73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionstspin.bash" => "tspin"
    fish_completion.install "completionstspin.fish"
    zsh_completion.install "completionstspin.zsh" => "_tspin"
    man1.install "mantspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tspin --version")

    (testpath"test.log").write("test\n")
    system bin"tspin", "test.log"
  end
end