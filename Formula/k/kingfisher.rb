class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.98.0.tar.gz"
  sha256 "fa312347e741062a8568f3ace8efc7cff140b506b0d6453bf5cb8bfe5e986781"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d0763e78b7b667d321fad3bd760755d97885cf029c449ee3c75af0ef0cadce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3bb9d886901984e4f5422d65d9659982dd0af048a44087c8df3ef123edfcae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03f84d78ae1e4ac920e2655631e5a62f25059b123f8400de6490a84a5be27950"
    sha256 cellar: :any_skip_relocation, sonoma:        "21fb972f7a13e67e8bc698fbac408705de4aa8563e3470593220a1ee4d0f45b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88afa93e9e121744651af6d6f0efaca927366f26c2920680610ac1b79264663a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4daa06b89f4d53a8eb86bdc7e2f6636ef846d68a6e7530140c3ac2cc952a2cf3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end