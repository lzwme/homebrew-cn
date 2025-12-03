class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.6.tgz"
  sha256 "c136a020c853b9cd0ea855307b5764bf05934f09411603a6b2568fbae27c6bd8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2abafeb1dd2a0d99b86038caf64d42ad7156962fc49d8bd27505563f9b616168"
    sha256 cellar: :any,                 arm64_sequoia: "31449ca6a740875b7c9c122c4ed711179b0e21076f1959c8926bb7a04d868f19"
    sha256 cellar: :any,                 arm64_sonoma:  "31449ca6a740875b7c9c122c4ed711179b0e21076f1959c8926bb7a04d868f19"
    sha256 cellar: :any,                 sonoma:        "e58d1cacde679484aa4382aa561b335adc48a91b8260dece64b57e5c7e9a2ea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "531b83706a3a7f078f4e3333a58e9c71a131e50137a84f2ba68d75d59b05370c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c115558779f7aa53d75ac8c197ef166441b0837748070c3aa648852f7a3b9131"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end