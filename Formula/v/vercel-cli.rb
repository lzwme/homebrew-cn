class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.13.2.tgz"
  sha256 "31986eb7ddcf36d672dda43906d687a30e510ebabc8d88bba77e2b1be3994cc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5ea6cbdd8a5ed3e9906d14c1468ab8a4fe9ac9d3f1e5b8ce77cbf7785a6fb04"
    sha256 cellar: :any,                 arm64_sequoia: "b3b362ea1351d948f3d460a04b80061555af029e1a3f9f23d63f2baa99e876f9"
    sha256 cellar: :any,                 arm64_sonoma:  "b3b362ea1351d948f3d460a04b80061555af029e1a3f9f23d63f2baa99e876f9"
    sha256 cellar: :any,                 sonoma:        "afb19acf2b83ba047b748d09a842b71d40b22cf93d7604d91010b632d8cfb134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2fd18bf76beba85eac2c59679ab49a2c50a480e690a3bf467b2276e14ac507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4276ad43a22a8ae343b577d501b75931b7f35b10ea41b17d673f5ad32c866e1"
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