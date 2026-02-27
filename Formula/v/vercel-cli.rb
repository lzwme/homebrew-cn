class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.0.tgz"
  sha256 "121d37f5be98af256e8d3104bb960da770439668eda716851a3196999109b7c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5722f1c21ef9289038ab9621933452cf39fcbb8002ed11dc0963261e85c3b5a8"
    sha256 cellar: :any,                 arm64_sequoia: "e0bf35a8474db511cf4352cf301a60396b0d6550574dc2ece53ca5b165ef809b"
    sha256 cellar: :any,                 arm64_sonoma:  "e0bf35a8474db511cf4352cf301a60396b0d6550574dc2ece53ca5b165ef809b"
    sha256 cellar: :any,                 sonoma:        "1bc633ea0804193aaa765fdb9fbef8825bc9a21beb0bd90108ff63226ce9d306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb56968864cd1b8958b965e81fd97531bee45c130b265bfcf6e7ff97d0e0937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bcf9844cc64e0bf4b1d26d1eb232af387ca569d9b28d9631f834105d95ce97e"
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