class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.18.0.tar.gz"
  sha256 "a0db6cfb5623396d78420778a077360d3c53fc0252cab28f76af657ddcf0c232"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58f017560e8010c8912d9146a56def5fc7a2bcbc78184b708ba3bc089f41db46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "416494a73ba68f4764127222a9ba1c9aca90400f79234db9864445282a408500"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19f63a746dc4d356230be87bfa04d0f375690760c7f4f87a4b0023aeda5a78c7"
    sha256 cellar: :any,                 arm64_linux:       "17277f1fb7a010234c851fae85131534682bcd323f3000215a0317cd58c0a022"
    sha256 cellar: :any,                 x86_64_linux:      "5e8dc97365dafd33b495ef5e06d76979ac5acc71cb13b7ea7c3c28e2e15e9f07"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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