class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b759ac7e27fde242c1cfaefdbffa9258f4b1e42fd4101bf7d4c5d1fb1be3db8a"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40219811812c5808d374296d243173379770b370b8ba97471ccc873d2a7db171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbd78c4f7ca3572322b7ee0cc619ff5c6d1255d225a66547f05fa6f0a4217a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e375a0accfb53ce1048dbe8978440b7fff116ec86181fabe151e67ffa6b187"
    sha256 cellar: :any_skip_relocation, sonoma:        "5074043fb4fe76951c64eed1ae009d7326303bd0b4ca0ca0f1bbcb11b608047d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "799be5e45205795be3a351af74151caf4483fc7141727fc568ba6184c02fe0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d362ad18ae0e26d60518898fcbdc81bc3e2c3fa9c05a3995fc13f5e60ffe84c"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"

    # Build and install the binary
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cook --version")

    (testpath/"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath/"expected.md").write <<~MARKDOWN
      ## Ingredients

      - *3* eggs
      - *125 g* plain flour
      - *250 ml* milk
      - *1 pinch* sea salt

      ## Cookware

      - blender

      ## Steps

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt,
      and blitz until smooth.
    MARKDOWN
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end