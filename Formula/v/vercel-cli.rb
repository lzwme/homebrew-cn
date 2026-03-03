class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.6.tgz"
  sha256 "68e9f32e1b75022dd3bc5daeba5149df4643f52772927b546324463602179599"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fda1e1c26cccf812aa9482923e5a249ea727fc7d1480a44489066728d6e17bd"
    sha256 cellar: :any,                 arm64_sequoia: "6ddbd33a8b06090f4fe63be88cedac660132d5c924a39530847317ca697a88ba"
    sha256 cellar: :any,                 arm64_sonoma:  "6ddbd33a8b06090f4fe63be88cedac660132d5c924a39530847317ca697a88ba"
    sha256 cellar: :any,                 sonoma:        "8358e1acfd9962822a7178fb60d9e5ec4468bc2dc670f9920b12e4e8d14430ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20a71ca1b108c934a27bff5b09c28714e9bf0a3a4eb255ae1edb9381fa324e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b131147d6e599c7acb2c784dd91f1b28d32ad5cb1587408609a45d9ba08a9f1"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end