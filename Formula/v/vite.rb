class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.5.tgz"
  sha256 "22f2f5cedcdc8e2283e1d629f18584b34d61a3d424673e43eedf2a9f2fdff34b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb498579f3068aed5e7e946615d2e5ca7085014ae23967eacab5a2200a65e534"
    sha256 cellar: :any,                 arm64_sonoma:  "eb498579f3068aed5e7e946615d2e5ca7085014ae23967eacab5a2200a65e534"
    sha256 cellar: :any,                 arm64_ventura: "eb498579f3068aed5e7e946615d2e5ca7085014ae23967eacab5a2200a65e534"
    sha256 cellar: :any,                 sonoma:        "9985251f7e05d7f8d8b9c964bae31034ba95ee5d8d9693391095cb5f3a132d33"
    sha256 cellar: :any,                 ventura:       "9985251f7e05d7f8d8b9c964bae31034ba95ee5d8d9693391095cb5f3a132d33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38212880b8d6fe13f5199bc7ca6020c678579ac1c4c3df4885baddc77505353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086267485d8b97c202d7fe9ae67d6fc9c772355a014ba7b288bec7f31881c07e"
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