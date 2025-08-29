class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.1.0.tgz"
  sha256 "b12f183dbf5b5a573f2a5ece675be6787ff46daeda72c3dc56b0b6bd40380b38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018a9e411cc0644dc89409893399952a976e7ff442de23e6793cf695ca3e6108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "018a9e411cc0644dc89409893399952a976e7ff442de23e6793cf695ca3e6108"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "018a9e411cc0644dc89409893399952a976e7ff442de23e6793cf695ca3e6108"
    sha256 cellar: :any_skip_relocation, sonoma:        "30a7bb7f8b1000879f81fe28781f7fa3f11d95e40695e87294f04a809581367f"
    sha256 cellar: :any_skip_relocation, ventura:       "30a7bb7f8b1000879f81fe28781f7fa3f11d95e40695e87294f04a809581367f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "685560317d06c0aea23ec2a8718e49472e8281610e26b969d861498963098896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54c3325b9b4ec4d347832a4eba67d982d7fc02e98cbf28b260020822614feb3"
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