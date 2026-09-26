class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-60.0.0.tgz"
  sha256 "a7b92510834a0e98f9a3a6e74708664a2f53e1ac5f7520e0fe124ef2417bf169"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a4d919db023da7829d14e37785204c15fda563f2e577e45bfe5a2a5df455ce60"
    sha256 cellar: :any,                 arm64_tahoe:       "a4d919db023da7829d14e37785204c15fda563f2e577e45bfe5a2a5df455ce60"
    sha256 cellar: :any,                 arm64_sequoia:     "a4d919db023da7829d14e37785204c15fda563f2e577e45bfe5a2a5df455ce60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a087f35e2a7c370a39c44a028130996ba04c367299607a60e01702b5a42765c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c535e6933e9750623f299b3f8668745230707462163ffad20bdd6a6ccaff6774"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end