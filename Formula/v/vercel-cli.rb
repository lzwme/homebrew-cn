require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.1.tgz"
  sha256 "266c3dd6b94ba0ae8c4d349b45261c3ab64ff9db3b650ad344fcdf4062f7ea42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcb7800b1abb647b7638c62bd05831f5bb15ef1e981b801800be04f34c20d4d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcb7800b1abb647b7638c62bd05831f5bb15ef1e981b801800be04f34c20d4d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcb7800b1abb647b7638c62bd05831f5bb15ef1e981b801800be04f34c20d4d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d01f72eec78218d5a07379e7cba8f15cfa97d1d7be74f5d1c921ba06e4ef2491"
    sha256 cellar: :any_skip_relocation, ventura:        "d01f72eec78218d5a07379e7cba8f15cfa97d1d7be74f5d1c921ba06e4ef2491"
    sha256 cellar: :any_skip_relocation, monterey:       "d01f72eec78218d5a07379e7cba8f15cfa97d1d7be74f5d1c921ba06e4ef2491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd77e67658886078275d8db313e3a9332d546c77966a4ee8ac8eb1d19c3150b"
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