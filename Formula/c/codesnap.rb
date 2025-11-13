class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://ghfast.top/https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "67ea9342913f4c974c0f6dabfe039509d3ebc4ed671196848a8f7474c7cf5a42"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53bf54d9368e93213e8686790b5f185cbcafad22dd339aafe2368488e310ac8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0dbeb179afada0a6b2a841f2cda76ac1c0d1c9012cc4fcca236b6a46d4e44a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1a43e9f8d22c5f6c9d2105ab5ca7ed7efef59fb0b6b4ed87c948beb9443601"
    sha256 cellar: :any_skip_relocation, sonoma:        "5648fa530969a21d89d1cf099838615e86a99076fb25308ac9bae793e7590769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89413743db625a4f248a7739d890774bf33bede50fd828812139265aa5b03d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1cc52a6e3ce45272d2b63a458b71e5c1554059de732c685f97901cb8120176"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end