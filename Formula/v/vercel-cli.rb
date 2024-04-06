require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.7.0.tgz"
  sha256 "29b929a5d370a5afde08f4939d05df4b808d4973bae147219d88e1eacfb1b445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1900427341dad3df784b1b7c62b8aa58015c7cd7d3d5cb6dcaadecd4311b58dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1900427341dad3df784b1b7c62b8aa58015c7cd7d3d5cb6dcaadecd4311b58dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1900427341dad3df784b1b7c62b8aa58015c7cd7d3d5cb6dcaadecd4311b58dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ea1875483389a4ae9416d7bf7c6a745e7bf27fc7a10b74cebd2ec0eb5f0640d"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea1875483389a4ae9416d7bf7c6a745e7bf27fc7a10b74cebd2ec0eb5f0640d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ea1875483389a4ae9416d7bf7c6a745e7bf27fc7a10b74cebd2ec0eb5f0640d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d4e52801ec88c97defea410d05ef74f3c97c4c1e68ec252c3d28ad32cbfb7dc"
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