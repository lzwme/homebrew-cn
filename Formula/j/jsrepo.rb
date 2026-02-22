class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.5.2.tgz"
  sha256 "ea7b8dfd01fc517742f2736a1a86e41e846d21f7bfadaa6d870e1119b21c2727"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6208bece667b26fce5c708fc8aa6ab0df5791f64c60e5f1e776fb997849665d2"
    sha256 cellar: :any,                 arm64_sequoia: "f95edb3923e839da3b1c9d594da2e28340eccbbc58c12d6f5e5909cb93f647e1"
    sha256 cellar: :any,                 arm64_sonoma:  "f95edb3923e839da3b1c9d594da2e28340eccbbc58c12d6f5e5909cb93f647e1"
    sha256 cellar: :any,                 sonoma:        "235263e6d086720b13a9be8531f51dbbd1ef2c3b7048594667fb37df3705387e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f182aae2446512982caff5e093408727839f7df0d63c293d21d0d140480f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f99d45d6f1f8a7b4d4e320016f8110fe8e650ec63155b683149708d041bdfb7e"
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