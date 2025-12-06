class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-49.1.0.tgz"
  sha256 "9ee563284389d3006c0e85170484e06c3a79233d66c43e393b27252e9a9e9f53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b29f2e739fc57f0356d587657ea35600b9c5bd6ad4deea050d952eec34369b3"
    sha256 cellar: :any,                 arm64_sequoia: "4f91360b0515bdda87891653d26986fbc1f0fa4581ff3f3fb008bedda6335967"
    sha256 cellar: :any,                 arm64_sonoma:  "4f91360b0515bdda87891653d26986fbc1f0fa4581ff3f3fb008bedda6335967"
    sha256 cellar: :any,                 sonoma:        "da820764c162b27e064e0f13821e037a6cbb97a39a3ad526f7763d74bb573c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95926dcf1e39f5a13986c7c0a2c936d17e6b71444c5fc287430b7978f104e8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4649ff4523ded5313a1fc7bc333d915f06b61ea86bd5a925609c4ccb2390be00"
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

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end