class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.1.3.tgz"
  sha256 "e2724e754efe608d204d0ec58f69663508c2bd668916d18e748a47f226378b30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada31af58953b169c917992a1ce441b2470cb10481106259a20ab74d90b6d1e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ada31af58953b169c917992a1ce441b2470cb10481106259a20ab74d90b6d1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ada31af58953b169c917992a1ce441b2470cb10481106259a20ab74d90b6d1e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d74c43c05a1176b4f8c775a70a03c9d64769748778aaf8e176b19b9dd5ef04f3"
    sha256 cellar: :any_skip_relocation, ventura:       "d74c43c05a1176b4f8c775a70a03c9d64769748778aaf8e176b19b9dd5ef04f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1431db907feee7ffbf79df8da15889eeb1b878713c9d4603b341f70bcc11ef"
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