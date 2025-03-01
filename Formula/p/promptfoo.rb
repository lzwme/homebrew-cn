class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.105.1.tgz"
  sha256 "3b2a1283476f6a439de3badd7b35b821462e88078e10e1754e715b92956b044d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab6e8f0ddf60965c41e81bc7118a8049e30c0b22fcce240eef772a68e874f40b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a4b4a9f1edc981b6496474ef41a7d71e185aa893c665ed1059e77d15ca55da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1bde36e9d8cd171a8ee26bcff25f48b647054be0321b3f67cf9aa37d325fc78"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a3c05354640fd4642678b19efc669a60ac43ac1e5e5bf790bc07accb4c13dcc"
    sha256 cellar: :any_skip_relocation, ventura:       "77381317e233f2d83d26c390480cbe9de189ef227bdf354c4568b9a5496d36e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c80d0214b5231eca5fae1727e86d657cfffe5031253b484596b6c0bea5e1bcb9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end