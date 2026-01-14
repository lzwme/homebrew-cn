class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.3.2.tgz"
  sha256 "910f334a4ce03d3f5f32d9ad7f80950ab52ad05f7aeb8887fca2a1ed93d4aefd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5095ef6ca04b8d675346784243f354a9ee78c6fc2881ab494553885cc9183aec"
    sha256 cellar: :any,                 arm64_sequoia: "b7a0a9a71340f09a33f3b77b432f3b040622ecbc7015f778b9eb1116311f06e3"
    sha256 cellar: :any,                 arm64_sonoma:  "b7a0a9a71340f09a33f3b77b432f3b040622ecbc7015f778b9eb1116311f06e3"
    sha256 cellar: :any,                 sonoma:        "1d86702bd4e155d78e049ba477ba9a94ae8b844645e7dc8942c323b11e7c7fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54af5424f41e707b8efa461e0e9f31f49a4b0be08ffe797525f4669181dac0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c444f34c9089ea178c8498fe440644d0b219a11799827ee9b5da8e55ff163504"
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