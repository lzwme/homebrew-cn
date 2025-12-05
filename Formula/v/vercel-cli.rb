class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-49.0.0.tgz"
  sha256 "b7ab72e75a24a920e048b712a11d32cc280690c1ac2b9ed1ea859654d4938896"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "643212f3bc8a4dc20cf09d395eba42f33cf6a39c66e841bacc604ce75182b80f"
    sha256 cellar: :any,                 arm64_sequoia: "7641b7e7d1ae86f24fa865fb72d25bc7fe37917b2db6b9ef61d7b55b00d604cc"
    sha256 cellar: :any,                 arm64_sonoma:  "7641b7e7d1ae86f24fa865fb72d25bc7fe37917b2db6b9ef61d7b55b00d604cc"
    sha256 cellar: :any,                 sonoma:        "c9802c527889fcfc4ec270e15851a446981389cdb92ade600bd6abf01fea2c01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644f3ee250c7af6f42d7285add09ff9d2338455814193525b487649a587ce2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c034c05aa2766c31e525852418e539d8895a5888091609ae9c61706b95f9fb9"
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

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end