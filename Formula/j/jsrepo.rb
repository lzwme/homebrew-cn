class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.44.2.tgz"
  sha256 "2aced853bb6c1e85a2382b9206a20ace3077d6d45d43584a07e4c336370a5c38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15daf02f6765259c6175cb27a4c4056b9ef0d8fb26e510684d2440341dc12241"
    sha256 cellar: :any,                 arm64_sonoma:  "15daf02f6765259c6175cb27a4c4056b9ef0d8fb26e510684d2440341dc12241"
    sha256 cellar: :any,                 arm64_ventura: "15daf02f6765259c6175cb27a4c4056b9ef0d8fb26e510684d2440341dc12241"
    sha256 cellar: :any,                 sonoma:        "1637e6574a644c59ec0eaddf531f891c3715ffae0d948c47e3d69e9fa2e6b756"
    sha256 cellar: :any,                 ventura:       "1637e6574a644c59ec0eaddf531f891c3715ffae0d948c47e3d69e9fa2e6b756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f326129aa6ace0b0fd2996b246a483604f34a8736dca3d088711aff487089a88"
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