class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.7.1.tar.gz"
  sha256 "18b1590003c065813d2726cc835ae4a33c5ce0bd9de6255dfad0e6e9bb759169"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef486e1173101d34aa755b08bae05fab86fbdc7d5605623f658b074e9af364d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395098a3708d7871ba7db24dc4dfd67bc28d7df610c946793c2e8b53149514a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0210f88bf5e6d01fb9cd66acde8e1573805ceedf5cd4070e9c5bf6ae0ae566b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffeef2811d87218906242ad976477e9c7d44ba237d56689d01275ff89892b2b7"
    sha256 cellar: :any_skip_relocation, ventura:       "81b7e5aff92530b27d05d622be345a0fdd642ab1daf47c09524df04fe7bbc097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92d8a20e4eaa66e22d059c7ee4d8d8ea0310e3cedfce514925dc8e6f5049250"
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
      assert_match "Preview", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end