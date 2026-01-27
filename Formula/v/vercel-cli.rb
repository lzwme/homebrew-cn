class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.5.2.tgz"
  sha256 "a127b8a5672df25a69538cebb0e7d198ff02e2a07819bf744cf082048220ba2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5393e9e589e2ecef59e49a0d46f575986824e7f1ef4ac76dc2937c8948d7d5f4"
    sha256 cellar: :any,                 arm64_sequoia: "addfb7e31b0a5d26db4bcd7671ac6fa3fd17e1386e3c636fb5e2e9bf0f703390"
    sha256 cellar: :any,                 arm64_sonoma:  "addfb7e31b0a5d26db4bcd7671ac6fa3fd17e1386e3c636fb5e2e9bf0f703390"
    sha256 cellar: :any,                 sonoma:        "0a58561b8d91d77e70f624ac94eac1540ee583b3d13688f43733ebc01f65a3d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ed7d2203877cc212e58b05fd207e9dcbd9da879ce9cf04a3ab2fa92fc43cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da03c8ef63d107ad7415a872ce637f6c81271bc4ea1c6c63a66caa3d0fc56b2"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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