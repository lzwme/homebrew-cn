class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.5.1.tgz"
  sha256 "fbe7b875c82983d40e802508ef2db7276b402d7358b8326898e156e0e067b059"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04b80afd8c71c7903f02a0480d5a44915e329b1172271e43fa125c9b999fe1c2"
    sha256 cellar: :any,                 arm64_sequoia: "65caa1a4ccfaf3c042aac3707490d4f937d52f0302997c3938131091620a002f"
    sha256 cellar: :any,                 arm64_sonoma:  "65caa1a4ccfaf3c042aac3707490d4f937d52f0302997c3938131091620a002f"
    sha256 cellar: :any,                 sonoma:        "a6a9a9535558bcabe6d4e86951e28ee9bbde3b911b2c9ca77d60ff737ad723e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65c5a2f4cd07a64923ba82582d79eaf8400d511ed489740e0775a643089acf75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a3b2cb8945b155cb6a4f99192468ef08c78521d73280b3b521d5296b2eb1998"
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