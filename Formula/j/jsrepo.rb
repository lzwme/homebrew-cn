class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.5.1.tgz"
  sha256 "b61ee53d55d340d19eb6d1fd89b13219525afc370ebd5fdccb8511abfaa91a44"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f72dc7388d9fe5d154daf2a3891201d91cbe8d86f6e8a4d06881071366c6ba68"
    sha256 cellar: :any,                 arm64_sequoia: "351f008e07df1af245097b264167f4a9aaf2679cace2d76fe91d8735875aff71"
    sha256 cellar: :any,                 arm64_sonoma:  "351f008e07df1af245097b264167f4a9aaf2679cace2d76fe91d8735875aff71"
    sha256 cellar: :any,                 sonoma:        "69925488b425eb1b421367a14decdf3f0c438606bfca86dddb79a6cfbdc6b1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b945c6a4007e34c931678cc05e46dea49547f55b0b6547d93872e81d43cd1408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3506e6a4ac536cfe8c8cc903e58140210cd6119c3f92b0bb4b04996974ab4266"
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