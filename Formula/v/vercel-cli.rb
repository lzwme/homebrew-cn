class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.2.2.tgz"
  sha256 "dd1d3e175486235395039960173cc1e2a7b82ace23750c3ab633e34855467f19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51826ff551bfde10c964459d62c2beb7d3bfd3597645131b09e0c71312fdc484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51826ff551bfde10c964459d62c2beb7d3bfd3597645131b09e0c71312fdc484"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51826ff551bfde10c964459d62c2beb7d3bfd3597645131b09e0c71312fdc484"
    sha256 cellar: :any_skip_relocation, sonoma:        "7685a3e10f2673a6f895a5d21d43b07e4590841cd7d0843ec40c98989b696593"
    sha256 cellar: :any_skip_relocation, ventura:       "7685a3e10f2673a6f895a5d21d43b07e4590841cd7d0843ec40c98989b696593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265829757f23490f4e792bf337acd1b16ee253a379bff0a14c139197c5f49e4d"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end