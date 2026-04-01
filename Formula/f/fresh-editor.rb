class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.21.tar.gz"
  sha256 "578036ffc1dde76aa0bfd7f5f1ae675268f42e09aa7f4d2b824856e282bcc758"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4724d5880121419cc93b23d42a2b54a282cf764ba7bde5780d3ac4cbc87ee50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90820ca00a35b2be9320fe9233ea1b5636f9040f0b623e3bbbc553375e331a1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b05995bacf2d384288170fd71962b57c457a171ed09819bc6b67bac08e2305d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1ba2d120a77b394d128f48e41f795b9ec40deb58cdc85976993c5b8b6f1c725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ab1c38618ef0ce0a1fbaed4f474aa106f0cf814d8151b4fcdd8e152dffba66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8aa76d560be67dadeadd8a0ce4682094b5efa96b7246db54b297608bf43185"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end