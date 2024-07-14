class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.11.29.tar.gz"
  sha256 "e1ffa2ee6b1a017930d5fd5f8155cbd3097762637faeb66c93ca7a8b4d7f28ac"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b6e9b278be94ad7e21d0efb64d5d1046b02809c6ec18be4ff37cb0068c120d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ddbe80387b8b48d2c760cedbf94f39634750f9a9f152577645f9efb71da5c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64f2418dae5fe6a99404ff39467ba5e755fe0dbb3ea1cee22856cb45ffb48380"
    sha256 cellar: :any_skip_relocation, sonoma:         "6706e2d4b991163adc53153283138abfb29beddf1308176e026f1aef51952887"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ef5acf590cb664813191436d43e07a0c0f602e4fa49ce981b0353122a26245"
    sha256 cellar: :any_skip_relocation, monterey:       "f63effb65fc93b3f082a2e0258e3ef1e3b5810de92403b629ada864ef5458f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01213b995e1a6eeb234140cbc67f24786cb989ec66b05a939ca6f461ffe7d12"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end