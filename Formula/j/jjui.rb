class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "f626daab6524a14955614b34c69fa3b35978821627d7a759e80d185dc0f5ff4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92bd3a2cd098340a96984cd19ae07240ddef220f1ff51623d429f690b636a933"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92bd3a2cd098340a96984cd19ae07240ddef220f1ff51623d429f690b636a933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92bd3a2cd098340a96984cd19ae07240ddef220f1ff51623d429f690b636a933"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1745ed631397edec19bb0cd77b054dab8aab244f1df028e16155c0b0aa9826f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e3fe2f4462644fa7bbf7e7610a6b2bd5cd3f4bbd4c8f7d5cf52f4dda65d7aaf4"
  end

  depends_on "go" => :build
  depends_on "jj"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end