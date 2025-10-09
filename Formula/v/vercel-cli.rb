class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.9.tgz"
  sha256 "2e49468e47b86ab104e1db2c4929b6870fd1254f6524607779bf94024ed37af0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb1e66a0fd5dd234b1558d9ee9588dd3dd707436b6e1fe1cf807fe2ae7ad69f9"
    sha256 cellar: :any,                 arm64_sequoia: "89278c8e03c0804152130b8f1f3b0e095987f05aab8b1907ea02729d9a6fd1b5"
    sha256 cellar: :any,                 arm64_sonoma:  "89278c8e03c0804152130b8f1f3b0e095987f05aab8b1907ea02729d9a6fd1b5"
    sha256 cellar: :any,                 sonoma:        "4858bb7068c81ebd58750f49f724d0ab1959c5e4d12c64bcbe8462d124e2c411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cfdb2d1eb9a1bffbd1dad79eecd73656856caf2c797532e747fedd7e2f15e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386772f29249742eeb465a89eadc627bfe08ec53993f47c18adb616eff83f49c"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end