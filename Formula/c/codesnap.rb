class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://ghfast.top/https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "b5cecb80f845730333f7f6ea06f167b575a85481908e8852de9b7f3befda7cb0"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16246614205fcfe53498a692c2e6a66098ae70df598ae887efff210143e2f5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c4836c7c5a9336feebecf9df06836d8407f42cbca631046a53c440df0eb3725"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f7fb9c1ff617a55ad48c92a3ccf93f872d9ddce64a5f67a22c3f3a0127d9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f65cdff2c2863ddc9fb13f14e1ad402a0ddde2607bd0f674d4f94690c4419c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "866f9040025c3827ce73bdfd384ec1bd0f920e0bfb7b156502e61c14d51d98db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710db0d1d1560ef56ed2c574a12e93362fd656d1c26216e5fcc656fc5648aeb6"
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