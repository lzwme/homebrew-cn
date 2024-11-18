class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https:ivanceras.github.iosvgbob-editor"
  url "https:github.comivancerassvgbobarchiverefstags0.7.3.tar.gz"
  sha256 "f859372839614af9102e476f643956a14b2334dd56819e5935d7192153cb99c2"
  license "Apache-2.0"
  head "https:github.comivancerassvgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e32c07bde74477d219d2266b7afa1748ce67bfc26ad55871353d2c2ba2f297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab59853ca30109c4eceae025555aa9cc09a325dffafc6e0793c7c652281920e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23309dbad0fd01e0de87a8b3a2ecbc79a41c70f835880e95ea3ccc6812e44ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b47e238ffbf33c0e2649198c1fceb9df3eb0e0974940cd296c93a0df06e4dc"
    sha256 cellar: :any_skip_relocation, ventura:       "f0f0fd5aea7eec08b9db8e1274783afef44ad3b635a398f7dab5018d6e154d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0891f49bb80e9a7d8445da24921cfeaacdda15be39cdc64f91a10f13bcc58b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "packagessvgbob_cli")
    # The cli tool was renamed (0.6.2 -> 0.6.3)
    # Create a symlink to not break compatibility
    bin.install_symlink bin"svgbob_cli" => "svgbob"
  end

  test do
    (testpath"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin"svgbob", "ascii.txt", "-o", "out.svg"
    contents = (testpath"out.svg").read
    assert_match %r{<text.*?>Hello<text>}, contents
    assert_match %r{<text.*?>Homebrew<text>}, contents
  end
end