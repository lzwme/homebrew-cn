class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.8.1.tar.gz"
  sha256 "b9f76cd133dbd60382a00705e4bed67727b94082f6c6a72d43fd6b7593a18595"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3825324f4dc1b82c58c2e32495e1c56c47fb6ad54d9060a1066a2d5d73b4f0b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "757c8de7d26c74ad941db65ee9c9cd24f7fcd30aed252e40986e70f5bb0e95f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0328c77783f13e117049d30957a87301968c33765fb139f2819757aa7049a20d"
    sha256 cellar: :any_skip_relocation, sonoma:        "76344a3dfdb87a59f49ea60b3bd280581695be68278fe02103686f848faf86bb"
    sha256 cellar: :any_skip_relocation, ventura:       "4a1a30323fdfe5d425dae73582df21b315273302bc8c2222e245b3da957ccb9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad0a03c8862b750273ce96779301856d2c00696171c34f208cb2823e1c2d905e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af497ce7981d11ad3cde2216dccdebf8b9b7f6425543df4e660ade0fbccb8fb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end