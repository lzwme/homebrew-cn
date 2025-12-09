class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.32.0.tgz"
  sha256 "2f717144a59a9c483ec079d23e4825647a7d9a911ee3fabacb49612c2a4ca065"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c1bdc96bb4c5fb52f13239c5c43e01e15a605f7bdbcc1789c2b6e7cbc158116"
    sha256 cellar: :any,                 arm64_sequoia: "224d5cd85d2b13b15f77ad39fb233f904b80aa46b594f24dd24cce6ce1402fe2"
    sha256 cellar: :any,                 arm64_sonoma:  "224d5cd85d2b13b15f77ad39fb233f904b80aa46b594f24dd24cce6ce1402fe2"
    sha256 cellar: :any,                 sonoma:        "bc8af0e255f9e993e361aac9e522f0cb7d3078b0aa03d529c821ec9a5e993c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9eda830d0ff15bed4573972af4d1225cfe8c8d803300f1d55942b84a53cbee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca8aadf8e3798f83e8f0673abb86444f85307e847adf7de7a6e361e0758bcb6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end