require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.0.0.tgz"
  sha256 "c59c74c3cdfd250c10167ce0df620504ae7ba97fb74efb54b820df4aadfc05e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86415d5624c43cc565866044513ff9d13a1dbf20884addee5a8c232ee3e85c87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bd23dede8f2c14ac1117e979197e6453ea1d18f9142a466a7f269340f1ddd6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9153be6fa065894a55696bafc6822bcb62a1f05c64851606d6c3846ecf184e3a"
    sha256 cellar: :any_skip_relocation, ventura:        "8663306c4d6e452c1ae653beaa7c6e8fb823bb4123b8a69df3a4be7247b5baf6"
    sha256 cellar: :any_skip_relocation, monterey:       "3ee77711849d64f9679fc934726674d0dae232d526d01b014e3a8cf1cd99f31c"
    sha256 cellar: :any_skip_relocation, big_sur:        "437fbaecdd5ae456fc22bd30b8c15d27951c3d74b1a9f9c7bccad09912565f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904ffd84007715c182229d36364f406503981d734c0f5c4183e5fef0ae37e9bd"
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