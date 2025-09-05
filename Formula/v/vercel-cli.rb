class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.0.5.tgz"
  sha256 "89df8d113e303e40f26d4cb62e799f162606252a15dfc67daa80fb6abdc64318"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "528e96de98dd931d4e2bccf42255f6a3619d843482b38f2d2ff0a8286f72dd6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "528e96de98dd931d4e2bccf42255f6a3619d843482b38f2d2ff0a8286f72dd6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "528e96de98dd931d4e2bccf42255f6a3619d843482b38f2d2ff0a8286f72dd6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f0a6700ca2a1de0a1ef8443b49545bfe3ccaca6f38641a0be66908b0cff961"
    sha256 cellar: :any_skip_relocation, ventura:       "a7f0a6700ca2a1de0a1ef8443b49545bfe3ccaca6f38641a0be66908b0cff961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed5cdfbfc4f2db1dfb5ebd98ffdd750ea0801d123576477a18c8a79e8be6a404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04bfcddb85c91ec25ffda657035a7d4d09d9c7869f53ef197bc8c7166f3de357"
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