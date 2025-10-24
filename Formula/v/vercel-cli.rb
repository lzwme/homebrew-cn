class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.6.0.tgz"
  sha256 "2d3ad341d602ad08bc9869326121860a305587d11d590248e9759c95db667651"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4090d77248a4d2f03773597479d85509ed89fb303ab284386bbffbaf7bb052be"
    sha256 cellar: :any,                 arm64_sequoia: "1b9b00c83485745168227f77b481bed318231845e90834ba49ac37a1d6c334ea"
    sha256 cellar: :any,                 arm64_sonoma:  "1b9b00c83485745168227f77b481bed318231845e90834ba49ac37a1d6c334ea"
    sha256 cellar: :any,                 sonoma:        "719dfe0221ecc9914085f640935f3a7d6a57254fb5801b1a4d71b45cf452b708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "113699cdc90e09fc08059da96eb4a38f720e1a991c2896cf54d537c412c804f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189d2fc82711d28c76bcdf5ac76311777f3eaac2874c4068dafdd22d5915c192"
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