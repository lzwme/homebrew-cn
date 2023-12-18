class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https:github.comtldr-pagestlrc"
  url "https:github.comtldr-pagestlrcarchiverefstagsv1.8.0.tar.gz"
  sha256 "900845c56bd87af990f6328b4762762bc7392cb93571080ee52df2c6d0fb9456"
  license "MIT"
  head "https:github.comtldr-pagestlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1be36419de69b877b8099e446872f6e713fa1ed1486270d8adfbb153fa9991b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69126e2e1f13ce69bfaf5ebd50c2ab96e39530559b2e7c4d3ef6eb67397091c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7c364e53bc94cfb822b9409d994cfb2604c04dfdd2754f1b1e08de55ca24b40"
    sha256 cellar: :any_skip_relocation, sonoma:         "024983c93d178909f6851fc7d597e1867d2b2dfeae32d7bed5234f5308d53014"
    sha256 cellar: :any_skip_relocation, ventura:        "6ffb5d854f92f44134be16b8e2b3ce9219625a8d05d7fff9955e7c50cf174ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "cb06ff3f3938a66e2fe59f93041d9687b4608c542df46e6be202fd265b7cd3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec66ae5e4927dc6eac0ce087c4dafad347416bf4d6bd61bf609b0be1f5a0f95"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    ENV["COMPLETION_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "tldr.bash" => "tldr"
    zsh_completion.install "_tldr"
    fish_completion.install "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}tldr brew")
  end
end