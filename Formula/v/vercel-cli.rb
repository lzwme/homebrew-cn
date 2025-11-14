class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.9.2.tgz"
  sha256 "3e1ebbeab4e37c8cda98782c9b881952d2523697caf9795e051fb99dc8781848"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af931f7ea7a8ab6f59dd85c67d88e63a11eabd3cf7a8b3324a47bede00929a32"
    sha256 cellar: :any,                 arm64_sequoia: "c5744239834c7dd220ea3cb5b2b39f8938733528554c3c07d8f7120b699d76e6"
    sha256 cellar: :any,                 arm64_sonoma:  "c5744239834c7dd220ea3cb5b2b39f8938733528554c3c07d8f7120b699d76e6"
    sha256 cellar: :any,                 sonoma:        "16f87a99b5b6f3a1fc7bd70a57a942e384b9260f08e1326e4231d7d386669726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce1db1304b1b6c4e892ef8dbda99c1e67240b56ea8d6df4cb88e97fe32aa59b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71331318f624b2fbd183b3afc48fe8d403a75fb5c7b919d770a3645c3a0daf42"
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