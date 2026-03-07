class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.6.2.tgz"
  sha256 "1f8c24948c1d7dd89a21e32859b6c05941e11cd970a1ba6433e440edf2406a84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71c797ccdd38d24c85c2122ec038d703e0a5b4187b123c45f326f0fe38b35ce7"
    sha256 cellar: :any,                 arm64_sequoia: "de93bff24f251142249bb07bfb7de8e2d5c55171e7d7317c15d7ad55e17a602b"
    sha256 cellar: :any,                 arm64_sonoma:  "de93bff24f251142249bb07bfb7de8e2d5c55171e7d7317c15d7ad55e17a602b"
    sha256 cellar: :any,                 sonoma:        "4254d177cbecf02a97158fd7ca328a00f6a07c35fe222776e9cdd60e0e5f1cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251f807282ea2af395b3086ff177f2962a98cb4bc7861b7c165a6d346d8cadfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0ba3253ad100d1a8fdd868f1dc5bc0fd2543c5a62d99da9d849df4467d373fd"
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