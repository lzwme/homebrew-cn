class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.2.tgz"
  sha256 "3b22a999fc2c308d4cc3db11ee42285d4862e58845a012317b6e1fcd25a2ca3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21030dec9402560e3be7006241637527b9a0abe96148855678e2a37ce111a9bc"
    sha256 cellar: :any,                 arm64_sequoia: "897bf00041b600ae112fc6898dc015d32625a972c63769bb3b62b4c3c882d6cb"
    sha256 cellar: :any,                 arm64_sonoma:  "897bf00041b600ae112fc6898dc015d32625a972c63769bb3b62b4c3c882d6cb"
    sha256 cellar: :any,                 sonoma:        "f8dca4177b04cee06238ef0d2ec05d749b52c37ead8108ced1961cd54d0cc556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "300fa191ca3d3376ad50fca4ba068b730a0a7e2eac44876dcdbe68f100893b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e06a1607de686488211868d633ca6a0d98c7b2410ff7ee6b95290e1d28b452"
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