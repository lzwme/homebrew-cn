class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.6.5.tgz"
  sha256 "17cf817315d74234947cc5a561ff3e6ced165637dafec15310c64c039392936c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5197d8d742d57c8745f3539a380558dc379442748ee7d062e1fe3a72c247109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5197d8d742d57c8745f3539a380558dc379442748ee7d062e1fe3a72c247109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5197d8d742d57c8745f3539a380558dc379442748ee7d062e1fe3a72c247109"
    sha256 cellar: :any_skip_relocation, sonoma:        "0634078b4b6b30a2678ef52e82771ff57943cb8ed55a6ea17bd0ce32dbad7f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "0634078b4b6b30a2678ef52e82771ff57943cb8ed55a6ea17bd0ce32dbad7f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01b3a39665813f14555d1beaa188bde5d1effb5d9f6947eaa808b2af1d0e7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642289c9f168298a3ed319fcdaeeba5149e59a8df9183f3c19535312f21c1ab9"
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