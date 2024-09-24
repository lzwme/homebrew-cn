class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.5.4.tgz"
  sha256 "21d7e1bab3f1f97940081a3f6cd57d675c560da874f6e5084200f9ad1fbc8c7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a9e42c581b747f71c39f15bda1d51070a4c5c0e4aa12970fad63d7b04c0cf4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a9e42c581b747f71c39f15bda1d51070a4c5c0e4aa12970fad63d7b04c0cf4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a9e42c581b747f71c39f15bda1d51070a4c5c0e4aa12970fad63d7b04c0cf4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e0f2368174b0c315422e9a75cb6c2638c29a8358fc3fe353c9dcf422f3e009"
    sha256 cellar: :any_skip_relocation, ventura:       "99e0f2368174b0c315422e9a75cb6c2638c29a8358fc3fe353c9dcf422f3e009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c160d1949b4908a2de130e09aeecc93a4c49bd87f41a78787635cb1b90150b5"
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