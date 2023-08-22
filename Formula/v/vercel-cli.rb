require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.0.0.tgz"
  sha256 "d10eefd62c3c10ce59db95a0a2138a3984b4427cae04457e3214c79e954e28c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e485126aa87db3a4dbe3c0b3887f17fe218507d74ab834ca2305e980625f69c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e485126aa87db3a4dbe3c0b3887f17fe218507d74ab834ca2305e980625f69c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e485126aa87db3a4dbe3c0b3887f17fe218507d74ab834ca2305e980625f69c5"
    sha256 cellar: :any_skip_relocation, ventura:        "0deee0196ecfe0c831c50f0036efb0b70b89f1c35dd0ff226ec02cd7e02bf3f8"
    sha256 cellar: :any_skip_relocation, monterey:       "0deee0196ecfe0c831c50f0036efb0b70b89f1c35dd0ff226ec02cd7e02bf3f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0deee0196ecfe0c831c50f0036efb0b70b89f1c35dd0ff226ec02cd7e02bf3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37bc17a8da85980cb2833e8a5cfcca02e638e2402f62fbc24d837dfba6da5844"
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