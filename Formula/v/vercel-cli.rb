class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.6.tgz"
  sha256 "1671ba8ced63fb99b1351f468db0589ecc5d9c6a0ebe589e90c40219ee38f6b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a8f6840225a28db939d46af8355c73760faaf4f93ec8fc6d64b34a3792a1f47"
    sha256 cellar: :any,                 arm64_sequoia: "2d2d8a9bec0e55f6aec3e7afa91d42cdeaff4f58b058b3e5e4ea7cdbbf1d6070"
    sha256 cellar: :any,                 arm64_sonoma:  "2d2d8a9bec0e55f6aec3e7afa91d42cdeaff4f58b058b3e5e4ea7cdbbf1d6070"
    sha256 cellar: :any,                 sonoma:        "f2c3840b66a04b6a088a8e3b461c1df95b370e63d6820698b42dce2b6db918f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c200d2763ce02a3d84f6428959deefa5012e52e89eaf98d3099cffa0b424d814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd26695720b7dab483f57dd529b7f749b495d126ed6f46b59b7aad0a984a8cc9"
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