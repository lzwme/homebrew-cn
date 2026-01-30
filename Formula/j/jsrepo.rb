class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.1.1.tgz"
  sha256 "0036730292f2687f97ab4c5a81a00d92e28f422356a965f008c3aa5deca6d252"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d49e21c0965ac82e1c1dcf81d622a735885e9f680449c346798ece4c0dc58e7"
    sha256 cellar: :any,                 arm64_sequoia: "392cd86e933e699077571ecc0478f88a5c58c81af084034c1d9465ed17971740"
    sha256 cellar: :any,                 arm64_sonoma:  "392cd86e933e699077571ecc0478f88a5c58c81af084034c1d9465ed17971740"
    sha256 cellar: :any,                 sonoma:        "de0f7006a0f5ff183975edc6b6b5fdac854336f0b5a3a5a78f968403fc79170f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c003fb322aec510eeb99655ed204ea12bc2380e021c9d8cee54168b1d499b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e61be4dca0f2a237a75a25f25950e3fc78272e50d92a24fd610a3db24f65cc"
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