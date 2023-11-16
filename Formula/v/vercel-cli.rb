require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.5.4.tgz"
  sha256 "f5c3e5912a9dae999a13be5aa089dff4f11e665183245f4f1fc11a564fd91603"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "353004f9637eb9a2e49b8b44d305acd5c004d184ff45d30b6aa8940030c06c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "353004f9637eb9a2e49b8b44d305acd5c004d184ff45d30b6aa8940030c06c6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "353004f9637eb9a2e49b8b44d305acd5c004d184ff45d30b6aa8940030c06c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5460b7a45f797fb44bdafafd345ce700001dd1852c40ca834358130222b70eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "5460b7a45f797fb44bdafafd345ce700001dd1852c40ca834358130222b70eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "5460b7a45f797fb44bdafafd345ce700001dd1852c40ca834358130222b70eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "526949914e3edc621b6dcc6771db051ba79b4f664230ce133dfe412b7846df59"
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

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end