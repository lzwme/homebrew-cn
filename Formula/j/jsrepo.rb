class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.4.tgz"
  sha256 "0616561e0fe61c19c706aa55deb3124e9a665d6c14815247affe2ef29adbb7f3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f42cf1148302e8b03d8cd5b818a4dbe97e5a15db6e9fc0b30b645b039f98914c"
    sha256 cellar: :any,                 arm64_sonoma:  "f42cf1148302e8b03d8cd5b818a4dbe97e5a15db6e9fc0b30b645b039f98914c"
    sha256 cellar: :any,                 arm64_ventura: "f42cf1148302e8b03d8cd5b818a4dbe97e5a15db6e9fc0b30b645b039f98914c"
    sha256 cellar: :any,                 sonoma:        "087628acf4a990edde90dd8df5702d576b6679c23d1430d84a8ca3fa8603288c"
    sha256 cellar: :any,                 ventura:       "087628acf4a990edde90dd8df5702d576b6679c23d1430d84a8ca3fa8603288c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "898b79b734d7eb70f10eac3732635da8d38b3cdec04d4190ade1e7b506bfd467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7faf92d8669f3e05ffab61d8c930fd8e09e91d6f91d83598513194eec0a813"
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