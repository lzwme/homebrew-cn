class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.38.0.tgz"
  sha256 "63f54881cb415254b7194ee12c8503da4ae7d8c72ce0d4da3a54960bb6689b6e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "04847931900d298fb6afcdb6a717a64e195a7ab5ae3c0a34f5b1f195faf783fc"
    sha256 cellar: :any_skip_relocation, ventura:       "04847931900d298fb6afcdb6a717a64e195a7ab5ae3c0a34f5b1f195faf783fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
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