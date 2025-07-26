class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.8.1.tgz"
  sha256 "a9713092fdb9aff0f4307e01a5e71b8c19dc436a9aa55f79a33bc91ca398d075"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9cb9b8c9e22cdb54d64da16078779ad10245887c9b9f615b7f5df441d2dda6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f9cb9b8c9e22cdb54d64da16078779ad10245887c9b9f615b7f5df441d2dda6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f9cb9b8c9e22cdb54d64da16078779ad10245887c9b9f615b7f5df441d2dda6"
    sha256 cellar: :any_skip_relocation, sonoma:        "056b088a58bff0b6364aeef54f2dc1d26da8c2aeef964e4b2d5c4d63bb7f28ec"
    sha256 cellar: :any_skip_relocation, ventura:       "056b088a58bff0b6364aeef54f2dc1d26da8c2aeef964e4b2d5c4d63bb7f28ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9cb9b8c9e22cdb54d64da16078779ad10245887c9b9f615b7f5df441d2dda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9cb9b8c9e22cdb54d64da16078779ad10245887c9b9f615b7f5df441d2dda6"
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