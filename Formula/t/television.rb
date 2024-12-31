class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.8.1.tar.gz"
  sha256 "bbab0b544574fdfb72ee44a121701d78fabf5a4aa276b7668ab9c3f84e54294d"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff365bceb1e17f400ac6d8f1b37c1579e57c13d57a40a180e75bc96889105dbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b9187f2765197980a2091593a86103b4d88855ff119d4c0b2b88b634823a0c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28b784279a4c8b57c9471b8c5005236b661cce35bd8840ed6339ec8b4aa92d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec823e0cef4a5357c697c1784b735bba1c08b2b8266e1588c11f70fdf472aa94"
    sha256 cellar: :any_skip_relocation, ventura:       "0cd5c940ca66cdd8b11a29d8f2ae800d1af79cbbd4d17e7845addbe1385cb5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6633c5c5210b3824cabae8d1328c010ce09c339bdedd9412558db1fa8bff0741"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"tv", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "preview", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end