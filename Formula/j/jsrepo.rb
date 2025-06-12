class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.0.tgz"
  sha256 "acc9f1683d1a92897286b866c49a5f5138012581fb5cbe331acefb53b982e4d3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2b4362ba2a2a0bde690fe1c5536f93f1d915cf2c0026269eafdd74c3834821a"
    sha256 cellar: :any,                 arm64_sonoma:  "e2b4362ba2a2a0bde690fe1c5536f93f1d915cf2c0026269eafdd74c3834821a"
    sha256 cellar: :any,                 arm64_ventura: "e2b4362ba2a2a0bde690fe1c5536f93f1d915cf2c0026269eafdd74c3834821a"
    sha256 cellar: :any,                 sonoma:        "acc10ad88c18df346e9af6d8a3679b6adead25d33889d46946452b8129cab984"
    sha256 cellar: :any,                 ventura:       "acc10ad88c18df346e9af6d8a3679b6adead25d33889d46946452b8129cab984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a211545fbad741ec48cd8ac75e1fe4dd5f5bfdcdc4b3d2c27bafde2d87c14bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bad96c2940b0096ab1461c623d55a8bb54278210ddc87524263c52d6f9676c"
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