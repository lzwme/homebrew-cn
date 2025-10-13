class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://ghfast.top/https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.13.18.tar.gz"
  sha256 "9f817d410e493d734552f120c419730c668bd4e5d14fd00ab208b29bf2aaa387"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b240422fe58922b24803d4c8f5831da7f7b4dd36dec7ab3757b4596152315ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff803f16fbe3333da8db943a58c73583ef61e7f62dac3c15a9d2ce17b8b09f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072c0192042b9aa7ce98f881d0c147869fb0c2191764ed2a7fae10f1f3be413f"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c986e285f17c1e59a0b07a5b13d5868031d70e11c93a9f2695490de4d95451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b41bd5981eb41a879ec88748a1b090ce145de90c74f3a42464f5bf6dcd1bf5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a83f495d4bb7bada45f42de2c45f6cb3bdfef09f8ee44e409a2ab6051905a24f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end