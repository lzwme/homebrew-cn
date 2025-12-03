class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.12.1.tgz"
  sha256 "5e64d60a22f645f9fdd267f2268635025cddf43ba00dd9f5efa042e006a7c271"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "233c24e8a4c2bba5a34cc76e34fa58211a554890ccfc956818103f2f11af4d30"
    sha256 cellar: :any,                 arm64_sequoia: "1fdfa78592ef9c0169f5b2dd2d2eed6b990f441884f6ce7e90f4527cd5e12e92"
    sha256 cellar: :any,                 arm64_sonoma:  "1fdfa78592ef9c0169f5b2dd2d2eed6b990f441884f6ce7e90f4527cd5e12e92"
    sha256 cellar: :any,                 sonoma:        "92883af24031d32dc517dcecd96ec454409c21ced01fb811607ee733aa60fd5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33beab9c6cea7606d72138e062254693de743cd299c9196520d7819d7674d46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f3e7b4c941bf5e829aa4c3d67a3b97fe808274d21fad7cb0c16cc9636f6511"
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