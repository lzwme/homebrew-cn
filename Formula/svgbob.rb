class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/ivanceras/svgbob/archive/0.7.0.tar.gz"
    sha256 "1600155b968b74b22f83d3ac6fb8b3daf127e4794d0e6acc9ad8e9e548ac6a6b"

    # patch version constraint issue for `svgbob_server/Cargo.toml`
    # remove in next release
    patch do
      url "https://github.com/ivanceras/svgbob/commit/b575ef693c8e2b439f64be8b1e07bd40ac5b0ce2.patch?full_index=1"
      sha256 "3a48278d2e1e51771d7995e8102c3f89a52fac51bcf95094df6408f95826de0f"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e6faaa806d4bbf92e80f2a6ab7901ec5fad15a960ddd59e28c1b9879a2b1d99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "231b4d13b647e04d88f7a9ed43b21ee408c297d4f4700ea57b8d9408b42440e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c0959ddd2bf8e8851a3facbbff9104680be0337eb03afe2d59d153e988d3dee"
    sha256 cellar: :any_skip_relocation, ventura:        "51417717ae672ef7e5a4aed49adec423293094d0ab00bc018394eb8bc1e1bb12"
    sha256 cellar: :any_skip_relocation, monterey:       "67b3a3e0df84d4a1c678faabcd4fa02b1dac11c12d3cd26762b4432864fb36ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "79028f6777a324bb547705943016950ab877fb2e87c2a7395db07699fb3d346d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1842bcf3732971351ca6b86cb99da773446e4d36b6983ce1f777054b5494d5f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/svgbob_cli")
    # The cli tool was renamed (0.6.2 -> 0.6.3)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"svgbob_cli" => "svgbob"
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin/"svgbob", "ascii.txt", "-o", "out.svg"
    contents = (testpath/"out.svg").read
    assert_match %r{<text.*?>Hello</text>}, contents
    assert_match %r{<text.*?>Homebrew</text>}, contents
  end
end