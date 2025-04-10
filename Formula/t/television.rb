class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.11.6.tar.gz"
  sha256 "b11448160d897bbb05fdf62385efe1436abffe60547d0692cb4b1c9f23fd9827"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89c4becf5ca966dd1e74ad30edf6f0e1dc20dfa4b9b6cd1373241084de3728a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "015f7916da164d26046225e047facc6417bf1eed6a46a85399cc7601b9121d28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d62edf0150fb28560545762ae07d6ec2929aab6af3462f23bcd58f916f93abbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "af0073f4c9fbe21d5834a3905c91289a13454d7089bbd97de0247500fab49bd7"
    sha256 cellar: :any_skip_relocation, ventura:       "d80e87f959a5534c8a34850ab4bc29cb283b52fa9db854a45e32ede765b338ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58f3388225f0ef250a7cc41fce6495e0dbda418de3e8e9c29e6f96aa5a9fd1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b2972d9e460ab664a8e436794b6eb8a7f3a5e08104befad0b640e06eae0b65"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end