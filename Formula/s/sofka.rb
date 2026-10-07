class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "540a6b1a583f83d9c0108a4383443269c21a77d4b5af7c002e81617a57d26f6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00d779e8565b43770bc93bf28f0a09476920f95eec055a9e0144df13452d4601"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9da4ebb65d19a9d7b45a06d7179a17f4c2a1b65fed226d08a7ff270355c92756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45256d1963af75ec72222dda14d56482fd8b2c962cb8c5c67db6ab66d9aee49d"
    sha256 cellar: :any,                 arm64_linux:       "f1af9f44fb76d4cc853a2b2e505c92118f3322effa5ee551f37f4fc111f919c9"
    sha256 cellar: :any,                 x86_64_linux:      "857274914bd793633bba4cee47af306ee507689a908967ea586228b29fedafa8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end