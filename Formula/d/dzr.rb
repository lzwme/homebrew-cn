class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https:github.comynedzr"
  url "https:github.comynedzrarchiverefstags240704.tar.gz"
  sha256 "003e56d73fac350e90c69c726a7871d1ff382faee33cb05841c35056209fa224"
  license "Unlicense"
  head "https:github.comynedzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ff93eb31b32dc10416abaa32061fd6f3ab879ccfb1d6fa0d427097f9dab00d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ff93eb31b32dc10416abaa32061fd6f3ab879ccfb1d6fa0d427097f9dab00d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03ff93eb31b32dc10416abaa32061fd6f3ab879ccfb1d6fa0d427097f9dab00d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03ff93eb31b32dc10416abaa32061fd6f3ab879ccfb1d6fa0d427097f9dab00d"
    sha256 cellar: :any_skip_relocation, ventura:        "03ff93eb31b32dc10416abaa32061fd6f3ab879ccfb1d6fa0d427097f9dab00d"
    sha256 cellar: :any_skip_relocation, monterey:       "03ff93eb31b32dc10416abaa32061fd6f3ab879ccfb1d6fa0d427097f9dab00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8df73803bbcfb522dca235a74f7baebd3174874d52ceeb3a4f1ad9a076b204"
  end

  depends_on "dialog"
  depends_on "jq"
  depends_on "mpv"
  uses_from_macos "curl"

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}dzr !").chomp)
  end
end