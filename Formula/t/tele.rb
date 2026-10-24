class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "624ec141319f931c6c14625bcf65ad2087eb4d30fd831e59096ea5badc03dc2b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e7585b7827bfe73af98c4d04b132ef0d769a9dfeef6e91a8b6fdfc56bed7f83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b480898a265d09078059b90b6e6af02c632fd10830eeab589b629cd8a83a4f1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfe4b2f3088907260e9ff5b0c63ca9106fe27569f3f64b002f7b57342ba04ff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9cd5282823ff17ec4179a1f37aa213630e66e1821e533f15e7fb85b2f0395019"
    sha256 cellar: :any,                 x86_64_linux:      "e6f24a4234a321f73e8ba7da304b68ef1786ce6437229c6f45230c5a0e52d5a9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele --version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele --theme-dump=tele-dark")
  end
end