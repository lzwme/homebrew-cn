require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.7.2.tgz"
  sha256 "ec395707e660b3fd0d6e8b527a907a05c09df6db1d65b520cebe50ea00203d11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5568cada7a3e2cd156c0c26060e45ebf334af43460bba458ca2326d0e21c5912"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5568cada7a3e2cd156c0c26060e45ebf334af43460bba458ca2326d0e21c5912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5568cada7a3e2cd156c0c26060e45ebf334af43460bba458ca2326d0e21c5912"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dd29b0ea2bf900ee31006f966e077dca9d9c1d85ec42502be5a1846df98ac9a"
    sha256 cellar: :any_skip_relocation, ventura:        "1dd29b0ea2bf900ee31006f966e077dca9d9c1d85ec42502be5a1846df98ac9a"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd29b0ea2bf900ee31006f966e077dca9d9c1d85ec42502be5a1846df98ac9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c78e0fff75be59504154c92db78610b4d008e77f52883f79efcc5123fc9fe1"
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