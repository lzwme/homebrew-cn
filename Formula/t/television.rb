class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.8.0.tar.gz"
  sha256 "bd110e3ca53bd9eaa20aad66015f1eb51ed6945b2827ca24d7c6bf7ade74a63a"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61481f04aa5ae55130073b931a38286fa2b54002c3f2cf0e8e59b830c78462c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec111c43f4f274f802d21051327b618da00a777fce9c91916544a577fe71f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbdd92c445d24435d769ba5218209254ed71abf0a1f632cdb77d6587b78e8dfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "8460986ee0b117eac9969161377f5c9cd62a953141b0b24bea86d722054c916b"
    sha256 cellar: :any_skip_relocation, ventura:       "0fef537e444780b1ba57435db454e3fcbe605611269058d48a7b8cc2ef99cf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e755e57f9ab65551ac0b8732945a646efc485e491af857acce32587f2154c1eb"
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