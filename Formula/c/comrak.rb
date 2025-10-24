class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "0fe58e74bbc47705192a25352e131cdf1de1f868b614e56c9b28b714db010500"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b4157eb2a49e7a33816bc165c22b36fa0bbe7508b55187ad1b78f11b45ff79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "563bf97c836cd5c58caab4c2f9ee5882bac26d1fe158820939dc9a9ad9da9218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a90690922bdd95789392541b54001c043ad17f9124b833b49a8dc0f816374c"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d318f1cee40985c05db84d5d11fc25a88236cd5c0430c7d9e3bef3e4eb2e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2ee0627bee61f34152238dd48e321739888c305e49187ad014a4333b7e4696d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6737d676f193f90ecd777c9e4afe62ec28497e67b93bafe1953c7878be1872de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end