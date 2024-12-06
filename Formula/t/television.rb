class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.6.0.tar.gz"
  sha256 "ce2ebd02b38b82b1d7ee7351f1309a7788101762729aad7b2f12edde7c812ab1"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9b2508201c411536d45623615cc11a763c502a41c1bcdd1880f160731f5c713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffa3a5ba9062532337b94416ecad3ba0792b00f6576fe1884a2898a065c5ef16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d683bc4fcb80930b6867bd11c9b3614e50d1dc014dc6201bfd4267c3682238b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "941d07f8a4534cb7838ee371f7b3370b14483b968f3833488b5000a0ae41311e"
    sha256 cellar: :any_skip_relocation, ventura:       "aa4c58b7e26b00628c13a1c7002febfe9f472196c0d9d7bf477dc59be07c0b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22d4912d5bf5ef2578507c8a6e6164185b5c07356916bced9c2d3cb89887fb6"
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
      assert_match "Channel", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end