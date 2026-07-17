class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.11.1.tar.gz"
  sha256 "f87b76adfc06dc3a743e8730c00ed471104f890961dadd64c1c4edfd7204cc45"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cdac402270884ce51062995c05e6c8324510dde2c2a53cc8f717057a5b57f4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7e97c12a269bad67e4f0206b5d6120269a4274d71805605adb44d71a6d1767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30ad93eb72317d4c7eb56ba03a7f017839a3a40878c260067e3a5db6bbcc10cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc36c2c39961b43fa90c9570c56ed921822ba8a81ce1a7b4b37379b5281ca7a9"
    sha256 cellar: :any,                 arm64_linux:   "e0d74229245aaaa4e538507a51b5408523127418184c185aaefc46996a133893"
    sha256 cellar: :any,                 x86_64_linux:  "a2781c1ba678258b4a60e6e83cc7693be51e3d3ff487adfd34120c52b1d5a6d0"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end