require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.0.tgz"
  sha256 "dfcb3a8873da6837469298e46c9c17f9d531f0fe1b814537be0dd0d73ae485fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93ce115a00d6d44b4802006f07638e8126f5f6c58bdf6885deee23448d176718"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edbf7d445e88eb5027d03c7ba659733125789a0f34917cbe864a01c039aecb49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da7ae9ff35ad93d2ce73b4f897fc83ceda1e5ea0b80e268af4b295788e43e4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce153b64ccf1d50229c0774b07dd0a42e2046761def05a9178b475d0cee5b750"
    sha256 cellar: :any_skip_relocation, ventura:        "300517fa93c58ee4a62398e4b2e22ec7e1ab6ecfe9d8755a3e8b0d8271f281e2"
    sha256 cellar: :any_skip_relocation, monterey:       "a52fcc0a1d532065d6ae4b11cb0a1c3db6f8a614ab40a327e94832ebfac094c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee12f7654150f9d947281b0cca5cc6713e22ee8812a25c459b2523d85d7647a8"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end