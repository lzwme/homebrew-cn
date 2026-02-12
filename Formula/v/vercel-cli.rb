class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.15.1.tgz"
  sha256 "09f44a5eade0e3e3382f3e20d1ac32539f397f0c2207931821cece201fcf3b71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5b1dd86b59c934f501f0054d9fc2f6ea89fe978a8d5f9a4783cdff1c057ffa0"
    sha256 cellar: :any,                 arm64_sequoia: "6c014a488f1fcf26b88a6c854b43c70b378332226097eee7bb28a81040af6211"
    sha256 cellar: :any,                 arm64_sonoma:  "6c014a488f1fcf26b88a6c854b43c70b378332226097eee7bb28a81040af6211"
    sha256 cellar: :any,                 sonoma:        "87b2711cda20de1a3c59dd968b7aafffb1745f67513011d0fddcc2fe471dfea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9a188268a67f2847459af7a44fc196f75de9e3f47b97fb0ae5276060b07019e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c7f0effbb9125d522ba50a46a9360e56aa85f117c50e74730075cb1926bf632"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

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