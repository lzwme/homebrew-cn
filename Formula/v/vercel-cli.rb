class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.6.tgz"
  sha256 "d946905346ede65bdaa5ecca50da82524ee3a5a9587d0e9a82c9f074298fd8f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cf6e51374e2d67ae19caa6655c8cd2fd712ac4bf8bf5cc3a529c942d1f2c8d0"
    sha256 cellar: :any,                 arm64_sequoia: "476661dc61ade369e30ce44362bf75874041e5372419238bc41e7c8f74c4edb8"
    sha256 cellar: :any,                 arm64_sonoma:  "476661dc61ade369e30ce44362bf75874041e5372419238bc41e7c8f74c4edb8"
    sha256 cellar: :any,                 sonoma:        "653ed8ab97418355486c3121c4e712e0c2fba5791f9b3d5f84f00136ea12c5dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0760911bd7fc8064310cad0dadc15521e8e4b4257d4831d6ff42c9215c894e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72e0a62c49ec6024940ef617186c8fc90c2d7bb3417632195c5a0831d595651a"
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