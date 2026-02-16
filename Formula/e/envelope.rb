class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://ghfast.top/https://github.com/mattrighetti/envelope/archive/refs/tags/0.7.0.tar.gz"
  sha256 "9851ab97d03e95083443d5a271f268efb54e65143867d28a1a239c76b4c441dd"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c6f45622100c1cd8b241a5201d084e1cbf2ddf65897e77ce8942a7510d28edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dda7270b15aba2a2bc4f9773ffcdd49aee4b9aa48088e78b6bf906d48cc7ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95d770a058cd7354f675bbe8fab6f59f70c8420c16214c9522cc7483b18e4ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed427ab33b213985f097e21b074ab4e66861bf56371a0facb620e864d238c71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48238dad8128009a40a73214395d980c6bab76d54e757795ebcfae96b35bfba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ae507f16874481f616970c12557169fb710645ac7c889f3f7b6f8583ea863a"
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