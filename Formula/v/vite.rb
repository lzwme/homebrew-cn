class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.6.tgz"
  sha256 "4eb5d38ba27b0554bdec0dc3125804f50bb648e4bce577377b5354da5a3a75b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cc251b1158d169fc126cfac32388fd19617a1e8ffe0203a93b704b1d24a0ad5"
    sha256 cellar: :any,                 arm64_sonoma:  "5cc251b1158d169fc126cfac32388fd19617a1e8ffe0203a93b704b1d24a0ad5"
    sha256 cellar: :any,                 arm64_ventura: "5cc251b1158d169fc126cfac32388fd19617a1e8ffe0203a93b704b1d24a0ad5"
    sha256 cellar: :any,                 sonoma:        "ce523a0c2e6742bb631aac51d6f7693c0532856e42c4a531e712c2ef1e95bf0b"
    sha256 cellar: :any,                 ventura:       "ce523a0c2e6742bb631aac51d6f7693c0532856e42c4a531e712c2ef1e95bf0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65edcc5cac6b7b5646a29c1047c8a2a5328308a32105a54fddcfd049f7f66dc"
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