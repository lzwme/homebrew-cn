class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.0.4.tgz"
  sha256 "d0cd4f7e228c1c79a5b9745b30c37767e6be7b930a9ef47e1669eebae542b5d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6bf9b99c42448f915dfcf7501d8933888af2e7eeca0fe280f13b6b3438d00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6bf9b99c42448f915dfcf7501d8933888af2e7eeca0fe280f13b6b3438d00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be6bf9b99c42448f915dfcf7501d8933888af2e7eeca0fe280f13b6b3438d00f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c18f325ca3e27b5e3bcb370662cbe8b1ad9b1f56d956ecb4f7040e2fee7a3f85"
    sha256 cellar: :any_skip_relocation, ventura:       "c18f325ca3e27b5e3bcb370662cbe8b1ad9b1f56d956ecb4f7040e2fee7a3f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf09f3a50889cbe1d9ea43f97faf491c77be6defd49d8abb60daeb660d1c4be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bee12c33a0e4073335bbce318feddf0fe2496611daea77ea916df733c6f47dd"
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