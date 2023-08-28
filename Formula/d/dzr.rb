class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://ghproxy.com/https://github.com/yne/dzr/archive/refs/tags/230827.tar.gz"
  sha256 "8eea9778ebd26001b81453612e15461be3906699f78a8b60e730cac0fd9c6f03"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6db5b2e2041808f01fba80aceeb1e063e08b3c83e74b4e5c7bd928520784a456"
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
                 Digest::SHA1.hexdigest(shell_output("#{bin}/dzr !").chomp)
  end
end