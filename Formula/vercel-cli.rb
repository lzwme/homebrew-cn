require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.0.1.tgz"
  sha256 "a83a348771d556eb168e8ecf594f654652573586b9bcf7c38d214caec9fd8b37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "435a107475a7d277c927173c15f9c6d56d5b34808e92cafe42a442411d966029"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "035fad79c9749375506da31bb8e996ef3c253a80ba2ecc2e7b201cb74df55bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf0b782970d11de79f5600ec0895dba7256a55c45fc94ad7c3ca1843b0e23c61"
    sha256 cellar: :any_skip_relocation, ventura:        "7d37dd9dbf7bbea4826e8ad602556e741f6f61b59507cd23a37380632a44746b"
    sha256 cellar: :any_skip_relocation, monterey:       "273d7193ecdb52b7bcfc0f34c60df45e2cd9d8c8eae4ba0703cda5c09e00dfea"
    sha256 cellar: :any_skip_relocation, big_sur:        "458ed845324dce456cfec855a9e3d153b1cf1984d3be65122c4a143937b1a0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a30034f8a83489f8899a4a8bf3f631115df72c886d4afc22349f0368a4ee0d6"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end