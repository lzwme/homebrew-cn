class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "3d188a410cc2b52b0fd4867aab7a26cefd0c47e2a47ab284105d82b6a06073b9"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97a3f873192082b11547fc2a6c3112c7d35e661a085a2f0ede3a4a7d9007c385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb62a3f07f9c189f3abfb3e7dc4cbd698bdd056bbf9926879b8f5125cb709f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d1c76a94f70bb15a1c48be3d2f34f603bbb60ea8478514acf3a244df1c9e1b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a896e9b2e9fea31217c50ee2b52a32d900a8694173203f10ab0e306d135e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6620c8bc4731edda6e47e16f4f44dd234dba61247c65edf51046a2e52c5483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08903dd5294e82844de635e7571f41a60903ce38919750a7e5316729d19670d"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build assets
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"
    system "npm", "run", "build-js"

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