class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://ghfast.top/https://github.com/yne/dzr/archive/refs/tags/250718.tar.gz"
  sha256 "6a4bfe183a3059bdc12e4465ef75b5468bfd6636cc6bdd16e0b6387e424ddc82"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b06753cb145a9dee98285ae33cca1c5f4a59866e8c894b5f5255ae32164cac9"
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