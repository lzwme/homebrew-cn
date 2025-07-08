class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.13.tgz"
  sha256 "493993ebf646aae374917acf85ad9adc0637dcaec1f20fff0dba4886ea4ad23e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a5c452d06ed2eddcc0719f547dddfae42f6a5f1603fad41748ff4b0c159139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16a5c452d06ed2eddcc0719f547dddfae42f6a5f1603fad41748ff4b0c159139"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16a5c452d06ed2eddcc0719f547dddfae42f6a5f1603fad41748ff4b0c159139"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4d3977c635aeeaf9e2988548c00c4fece7ea6164e39b42d7c49cab1bc3f68b"
    sha256 cellar: :any_skip_relocation, ventura:       "ed4d3977c635aeeaf9e2988548c00c4fece7ea6164e39b42d7c49cab1bc3f68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baaa100d9acca2d3d734e05904143dcb005d582ef06c4b0b609741f7fde4da23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ed6be0ee950484755e43969bd30cdcc2909ef4bb8e527f6373bca170deda71"
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