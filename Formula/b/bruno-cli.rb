class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.13.1.tgz"
  sha256 "17a77eba0f48713f7234423aded5315fcc207dec557e14c88c758cc796363569"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48fdd4cb9efa13c6bd87f58193f1e5085daa16129e823d4c659e753799a8bbad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end