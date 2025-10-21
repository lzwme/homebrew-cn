class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.11.tgz"
  sha256 "ca1c8bf2b88534097904fc6482d576e04c270b7acea81a64c85fdf049cbe53b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88c6f7a06cd771d93f3281861e2b2dea704ac403a8612c35bc704d14c829dfa2"
    sha256 cellar: :any,                 arm64_sequoia: "94b1e3df66a5ab7f23f175501021e93b556e23f5d6b97beffdd88bcf67063904"
    sha256 cellar: :any,                 arm64_sonoma:  "94b1e3df66a5ab7f23f175501021e93b556e23f5d6b97beffdd88bcf67063904"
    sha256 cellar: :any,                 sonoma:        "b55caddb680daa2acc69dbbe807029a245a056bf31d4d5e703e580bb1d171991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb23e33719c5774a793949a9cb57c4858fbfff11f7dfe6774ad2813e8032d685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f9bb1ac30e0377cc449319b5a828973cce9847fe10081f9801499b11a0209e"
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