class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://ghfast.top/https://github.com/mattrighetti/envelope/archive/refs/tags/0.6.0.tar.gz"
  sha256 "2d998fa7cb544e3896861da130faeebf37d77f565c1f014875a86e5b4246368f"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e6cd757c87259f7fc30a8a12b4b2c09255d2e24954e3d2d3dcee0d523afac71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721473afa3ac4a0d1e7a70eefa87b99f624b24605bbae87f314c26b8be3b4da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec54930525ed2a6b18374091f23fcc777e9b6fdd1cbc75e709d3202fd32e58d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6c9643a6f62a97c758db802f3345fa232f2cf025bb1260ddf42b2eba309cd4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419c7f2af22d0fbfe837fd488e09f09885aafa90340a137ec20c59c2c9fefe36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc5c227f95e93ff47013c1c3aca2fd0218d4566bca1b7594ed57a9471fe9a1c"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/envelope.1.md", "-o", "envelope.1"
    man1.install "envelope.1"
  end

  test do
    assert_equal "envelope #{version}", shell_output("#{bin}/envelope --version").strip

    assert_match "error: envelope is not initialized",
      shell_output("#{bin}/envelope list --sort date 2>&1", 1)

    system bin/"envelope", "init"
    system bin/"envelope", "add", "dev", "var1", "test1"
    system bin/"envelope", "add", "dev", "var2", "test2"
    system bin/"envelope", "add", "prod", "var1", "test1"
    system bin/"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}/envelope list --sort date")
  end
end