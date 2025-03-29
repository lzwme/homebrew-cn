class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags5.0.0.tar.gz"
  sha256 "bc694666876d06f2dde7b738d8bd9ce27e122d11bba7b6da923b1837c23c12ae"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731b09f4c5435e8a7687ca9a86f0cb170f7bbcf9ed350106fa0f63737cacac4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb1cf139949d0826dca7c36407d187687ae2d23cf57b62ff385f65e9378537ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df85eafd42278492751b2f52a0d21da31a7f6709fcf3796ee3a3c0265690b5d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c84b9782bea3790230606dd5f1f39c55aad0d1066ead82e764e8e49818fde1aa"
    sha256 cellar: :any_skip_relocation, ventura:       "1caca67b66c85a7361a788720e28366a2bcecdc766a9863443825f8060f5b133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd36daa4e75b4d47faf64fbe756e90f90145602f7aba5a262f2ce78af5660bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf7e1515ac5ca9a8c716506fd090d3e37e2a4b50ba7507eb921d7f299f123e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionstspin.bash" => "tspin"
    fish_completion.install "completionstspin.fish" => "tspin"
    zsh_completion.install "completionstspin.zsh" => "_tspin"
    man1.install "mantspin.1"
  end

  test do
    (testpath"test.log").write("test")
    shell_output("#{bin}tspin --start-at-end test.log")

    assert_match version.to_s, shell_output("#{bin}tspin --version")
  end
end