class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.5.0.tgz"
  sha256 "4d819636f60232097389506fe3f152272b798bb956a0b24851de92d15e1f8fc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d29675ff8205ebb95224d86fb6aa1d74efadca7c37faf5c4901a32ce1957eb07"
    sha256 cellar: :any,                 arm64_sequoia: "5df47a7076e546a73964e10c0ec67040341ed4c4d8f19ba725b80f454f2ea8a9"
    sha256 cellar: :any,                 arm64_sonoma:  "5df47a7076e546a73964e10c0ec67040341ed4c4d8f19ba725b80f454f2ea8a9"
    sha256 cellar: :any,                 sonoma:        "84fa8cf328384868396395654b2ec6c90d57876c9e8917effa9bd95c009a579c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95e11c9b32e48c31292a0caf346a96e2124003275601b5288b1cc232747b2f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a095e8e7bfbe494fa60767a4e4ffa53e0b1bfac80fc07fb0309930ceaeecea43"
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