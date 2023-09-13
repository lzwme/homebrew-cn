class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://ghproxy.com/https://github.com/yne/dzr/archive/refs/tags/230912.tar.gz"
  sha256 "42bc2db8adfa38d6a6c1ca851c2f32e9bf9112b98d71d2fa3bfa2c7d76580073"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b561d79192c78d522b4da3ce8430dbf0c242ec6ebdd0342d28dbd7c47ef88a93"
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