class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.1.0.tgz"
  sha256 "c0a03f930df31efe5fe00737c1b2ec700378e215431751e697e3f84d11720e98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae126d6f82640612ab4455dabb58eb69778a6303b64e52f6bf760cc40542109f"
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