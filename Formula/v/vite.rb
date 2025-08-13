class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.2.tgz"
  sha256 "2582c2adf5adbb25f80f24c46dc03548ae97ebab24379e984b503ea20b26286d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57c707ab02edefeafaa7fd701bbd6e895e7bfca67289653386fb1d8928d7786a"
    sha256 cellar: :any,                 arm64_sonoma:  "57c707ab02edefeafaa7fd701bbd6e895e7bfca67289653386fb1d8928d7786a"
    sha256 cellar: :any,                 arm64_ventura: "57c707ab02edefeafaa7fd701bbd6e895e7bfca67289653386fb1d8928d7786a"
    sha256 cellar: :any,                 sonoma:        "b207f674d8c0fa351d2f935252e326e59c902f3ff0b1e9011d328ab637249735"
    sha256 cellar: :any,                 ventura:       "b207f674d8c0fa351d2f935252e326e59c902f3ff0b1e9011d328ab637249735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41c71486a32854287b8e26f210da2a8a84538c4b3982c78fe105db6d2582392e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833b3eecaa854485295b7aab8cbb4dcf09b059e8b7ed385ddc836376aed595a6"
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