class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.45.2.tgz"
  sha256 "42e5aa1573f18e198dd123f092837d3edc97cf211c58717911a7a2bfd8db6e4a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "857c9565f16322e616a0e16b702e7828ad7a704503804026e36de3656ab214a8"
    sha256 cellar: :any,                 arm64_sonoma:  "857c9565f16322e616a0e16b702e7828ad7a704503804026e36de3656ab214a8"
    sha256 cellar: :any,                 arm64_ventura: "857c9565f16322e616a0e16b702e7828ad7a704503804026e36de3656ab214a8"
    sha256 cellar: :any,                 sonoma:        "9de8601d99795d9e603ca7cb6da9acaf41863650d54daedc402ab5b6c814f4cb"
    sha256 cellar: :any,                 ventura:       "9de8601d99795d9e603ca7cb6da9acaf41863650d54daedc402ab5b6c814f4cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b566d456475692bc64505fb670f786d0bbba10a92229d966f54f2e341fde54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b875e07e804ad5df6ae8e69ed7c5f59c3bc0924adca2aa1995eab4b166c69cf5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end