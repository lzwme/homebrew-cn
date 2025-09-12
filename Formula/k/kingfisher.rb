class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "8eace78aacb3c2095262a050a198abea94eba34573b3e8c6cbd24e7cbefbab30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61445a2e016521835c1d3aa9a4871b3f663c729c5de23fe9b6a0aa588af17ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68aea58dca70009689b87424e5fe8ca6f33605c7b7b2903a474c0e60a365bf6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e901b63307690df58665d7d830090f7846a29775969b3b5aa8497fa6e10815cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8404b943ce376efc048d0383528f0d7985b20498c8874b5f7e8574d34f8191"
    sha256 cellar: :any_skip_relocation, ventura:       "2720bbbb881006d635c4ed695697adc50b1b065414e9607caa101536ccc851ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "effde4d8209c22d03c604f6ddfa3b497aa0082b5da27857366aceff0a8ab7072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356d5cc42cf5d58340b2d45a2a60e550ed7bb14892ae2f109a9ab17df29d26a5"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end