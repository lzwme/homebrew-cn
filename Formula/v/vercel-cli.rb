class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.1.1.tgz"
  sha256 "716303316e3bf2ef57e9bb4ff91a97e67b08a763530b08305a2a0ea09b36ac52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df888971e2c5772682cd674d83849314e0a3f985ce151104aa8d1c5fdef5e1b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df888971e2c5772682cd674d83849314e0a3f985ce151104aa8d1c5fdef5e1b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df888971e2c5772682cd674d83849314e0a3f985ce151104aa8d1c5fdef5e1b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8631d77b245bf05a6a0189a36a0aea0aa2ccb91a5889f3571e8620c4488917b"
    sha256 cellar: :any_skip_relocation, ventura:        "e8631d77b245bf05a6a0189a36a0aea0aa2ccb91a5889f3571e8620c4488917b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8631d77b245bf05a6a0189a36a0aea0aa2ccb91a5889f3571e8620c4488917b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd763ca7af7ca1585c8118eda1ae914b78387d91cefeed531e8c526f269c287c"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end