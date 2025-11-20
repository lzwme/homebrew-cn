class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.4.tgz"
  sha256 "e0a18bb2a51092e3d32cb0404d289a192e3e32b9c92735e7c61254135c29aa36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0f71392d8322e84ea4962110a6954f559f7173ba088ee8f446ba3a1119aede4"
    sha256 cellar: :any,                 arm64_sequoia: "a0244b09993113906b9c21132a1c0aa187883fbc6a11379ab2fcbf24efa04e69"
    sha256 cellar: :any,                 arm64_sonoma:  "a0244b09993113906b9c21132a1c0aa187883fbc6a11379ab2fcbf24efa04e69"
    sha256 cellar: :any,                 sonoma:        "36e8a400af28783b7194a9b8cbb5ed1d7552f6cbf876ea5ec0ddac64b85d7083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eeca47c4098fb77037a1a52e2b60db39baa4403a937260c4c543480498586f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b52b75246f678fdbb7d408507785d556491869d864e7df770a5d57e3655026d"
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