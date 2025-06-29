class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.7.tgz"
  sha256 "573f5dbdc7d07cae189f15afa34517f4d0e57008304120d3b04a503583b66af6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61bda9f2a84b3954c6faeff7f7b5bd897a70c7a31bdda1700cb1c1756e179976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61bda9f2a84b3954c6faeff7f7b5bd897a70c7a31bdda1700cb1c1756e179976"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61bda9f2a84b3954c6faeff7f7b5bd897a70c7a31bdda1700cb1c1756e179976"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8584f5b87dab75280e5f6add25fbe1e3209f48cf6cee9474a16d96579c1cf9f"
    sha256 cellar: :any_skip_relocation, ventura:       "f8584f5b87dab75280e5f6add25fbe1e3209f48cf6cee9474a16d96579c1cf9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c1f0c55df6b2d66c4511b07b0d725767aa5b154e308403f6a771c4cc5929a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71ec1adc0b9084dbcc26d8f2eb2d6c62345b6a8ca70e1e404a8ed41bf31da929"
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