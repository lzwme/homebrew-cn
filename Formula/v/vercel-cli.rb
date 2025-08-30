class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.1.1.tgz"
  sha256 "cfe64d8912b4f4dd0be09ac282d027a993ce496211f029857143c2a914c7aa3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6be54adf2f91424b625dcde19c6ca7e995eccc0d362565c097f2c0e6416964ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be54adf2f91424b625dcde19c6ca7e995eccc0d362565c097f2c0e6416964ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6be54adf2f91424b625dcde19c6ca7e995eccc0d362565c097f2c0e6416964ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "0472c47b084694bd3241fa924a1453c194de6e70ca3e9c10ac7e83eaf1b890e3"
    sha256 cellar: :any_skip_relocation, ventura:       "0472c47b084694bd3241fa924a1453c194de6e70ca3e9c10ac7e83eaf1b890e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08165a93a928f201b13aab2e4d9961bc7385910f043067180b3992857f93264c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b12320e6da2b3bd11b96119721dd0c09344adfde9ff02039631f12cdc90fcd"
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