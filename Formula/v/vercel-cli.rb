class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.9.tgz"
  sha256 "c30138ab6069f652c10c8892bddcddb63f7e2181384ef8c366da6eb5c3e0458e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ba6ee5e7d878e3a68ec7970821f47cef1df2f94f9b3b8f247bb53b68a726293"
    sha256 cellar: :any,                 arm64_sequoia: "f663b22c13a5a4a138b78f94033b2d3e2277b86c802905b4e5b2db6c34689ea7"
    sha256 cellar: :any,                 arm64_sonoma:  "f663b22c13a5a4a138b78f94033b2d3e2277b86c802905b4e5b2db6c34689ea7"
    sha256 cellar: :any,                 sonoma:        "1bfa2660c68b6f94339366cdbfeca7700f106366fafbdcf72b49414ed0893e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dec21beac9198f1d9f1bb8041018931d7838b32176017553b6b985ca4488b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027b24bf0b8edee036af828a067167afe227490f5d1b06baa1bd3bc444356479"
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