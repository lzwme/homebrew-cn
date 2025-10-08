class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.5.tgz"
  sha256 "374eb29d41255a7fef91d8e156aa4613e7d873bfa023d419eecc2e64043c1ad6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3be2b3985c2068dc6f066026db183059724d875a738530fabb494f42fba0ff0"
    sha256 cellar: :any,                 arm64_sequoia: "a509d19a13d7c253e5489199999ea0d8c7c92f96eda74dd017d694717f8ccbac"
    sha256 cellar: :any,                 arm64_sonoma:  "a509d19a13d7c253e5489199999ea0d8c7c92f96eda74dd017d694717f8ccbac"
    sha256 cellar: :any,                 sonoma:        "c9d5b3c3a8ef49622112d5961ac67874385a7a94a1a99b5eeabfa227850e8641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24304d589e83e51ab5a05fdf83a1f267041b773a443b54914fca2c54dcf65b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f2b5b9ad1bea752c963749fefef2842d57cd250060a31215f00e694d5a6cb2"
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