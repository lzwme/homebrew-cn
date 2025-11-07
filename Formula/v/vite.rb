class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.2.1.tgz"
  sha256 "10539e7daf55256b06861fc95f875311bf7b97ce52d73f6569c75924628e19fa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2daa511a2f6d289f0b04b14a1229435dfed1d764fe61c21ee52e9b835b43b4b0"
    sha256 cellar: :any,                 arm64_sequoia: "34ba15e95224e8862b7efc06e5c236903c4dae352fa2835d59c27050a6e35b0f"
    sha256 cellar: :any,                 arm64_sonoma:  "34ba15e95224e8862b7efc06e5c236903c4dae352fa2835d59c27050a6e35b0f"
    sha256 cellar: :any,                 sonoma:        "3910b1e15e3d100d2caf643baaaea0f785d9b4f380d0a90d31e276c482b41bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4672ee349728497e09b21b1a9f73e5f5f18fe13862d4a87d319121606403a114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064d02983cda13b840a680797f7ea91630c7e3e5a91bd3725e6ca626ed11dd37"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end