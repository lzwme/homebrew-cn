class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.7.8.tgz"
  sha256 "3ea4d3b681004586e35032928f85dd07afcfd8f966462cc1f1ed806964e1769d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18469db7a6c116a2fb9c1898e56e2616237af167fe3b3bd2751fca7bc5484c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18469db7a6c116a2fb9c1898e56e2616237af167fe3b3bd2751fca7bc5484c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18469db7a6c116a2fb9c1898e56e2616237af167fe3b3bd2751fca7bc5484c2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "24a0bd8f0fe6770470503eb237827daf8910c77c500a0539126e4a32c0373e9d"
    sha256 cellar: :any_skip_relocation, ventura:       "24a0bd8f0fe6770470503eb237827daf8910c77c500a0539126e4a32c0373e9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5549f4c45155065aa34d89798d77cc85bb7c6ab64685af3b350d1e5f9b6a41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e231549028ff35afc70f154a75c87e0cf21fa0b6c9499623d6f68815c28659c"
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