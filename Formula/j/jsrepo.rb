class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.2.2.tgz"
  sha256 "f112c40c76a816ce57c90c169b3012737a823416e44247db54f7cb8146d09645"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8059148c1eb25bef88a2f2ad123e7299003d2821442f969ee1ca24aeab77a95f"
    sha256 cellar: :any,                 arm64_sonoma:  "8059148c1eb25bef88a2f2ad123e7299003d2821442f969ee1ca24aeab77a95f"
    sha256 cellar: :any,                 arm64_ventura: "8059148c1eb25bef88a2f2ad123e7299003d2821442f969ee1ca24aeab77a95f"
    sha256 cellar: :any,                 sonoma:        "62a71800051e0e707adcc118e49b4fa57d6f4cc0d53df4a23460f6aefb6d6f75"
    sha256 cellar: :any,                 ventura:       "62a71800051e0e707adcc118e49b4fa57d6f4cc0d53df4a23460f6aefb6d6f75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b565eb941cd89a631659e22cb3679db24702e02830df14bb337134526a8173e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414b9fb5ae5ec42c334c1c4887a5a6edabb2c1b236454085906c30472d4bba43"
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