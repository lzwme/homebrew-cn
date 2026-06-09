class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "43c9355980ca3ee275145ba710a4bd4d56c7ef271c5dc1fe4bbb43a00d7306de"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "06c39a1a3b0e73c25802349ad52e0c46b5f570771a989c23b871ff1ed73b7f62"
    sha256 cellar: :any, arm64_sequoia: "623ca3e55d4e618285aa1781316ffcd4bb7a32e6620564e56993f0ba047af4dc"
    sha256 cellar: :any, arm64_sonoma:  "ce2386ee8a37ca619b53cf817d4a9ba82036e3c14eb83fc04b2c010c7b5e7b45"
    sha256 cellar: :any, sonoma:        "85a072bb5fa600efcdf9116873d02669f88fa78a1adff5907036a24ee5618535"
    sha256 cellar: :any, arm64_linux:   "f4cc859606edf3333d8714584f30aa7bfd9aa33f69c86c8b51c7fdeecf982719"
    sha256 cellar: :any, x86_64_linux:  "0033cd4117da79dec0a3f1167852aca93fcd0388409c184a95c78053a7a46014"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end