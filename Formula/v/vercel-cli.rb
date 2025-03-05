class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.3.1.tgz"
  sha256 "51959a27e29b63cbfb7547c7a37675f3be040e6ccb49b339a4395371e533ef90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa74bc622785bd158dd98e8d54c3c17b246d9b81824714f42bafad49aced128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa74bc622785bd158dd98e8d54c3c17b246d9b81824714f42bafad49aced128"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fa74bc622785bd158dd98e8d54c3c17b246d9b81824714f42bafad49aced128"
    sha256 cellar: :any_skip_relocation, sonoma:        "06aa0b5532fe8cc0e28b95907deddeb4de7099bf09c12a13bda8b902714a7739"
    sha256 cellar: :any_skip_relocation, ventura:       "06aa0b5532fe8cc0e28b95907deddeb4de7099bf09c12a13bda8b902714a7739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00993fbaca8d4e69af56d1070ada25fb00595846a3b09ef941f9e7afc49c42e"
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
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end