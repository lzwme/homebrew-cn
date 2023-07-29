require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.1.1.tgz"
  sha256 "a059d5ffc8fd975eb29004d2c20fd790a0115a8efa4c62608abeacc947effec7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b23817afee058045283ba0b3be0225df90a1294ea28dd6bd4fff6a2f647f892a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e76fa38fc1a7da5513d5ffa3bd8056a8ea3097fdba032b6d5809120233c7b5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b675d7c23fd5de81ef0d8558fba2ae6a8fd6615d49f9fe68e8addfecfdf6026f"
    sha256 cellar: :any_skip_relocation, ventura:        "460e76a48a457502f6ec01c4657d0abea06048e002865490716623c29decd38f"
    sha256 cellar: :any_skip_relocation, monterey:       "ebfb13af433da1554127294a4910bf1308bb7af5de5af1dfa40b91ab3ef816f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "17216f2446daf34592ffe240dfab230ad2ffd50493ed16361ab95cf71e7e0845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa295b4ce89adc4a3fc051b63b74e2931e040ae06a478511ecafa2990f1172cf"
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