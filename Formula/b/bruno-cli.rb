class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.1.1.tgz"
  sha256 "fde91d629d7fff27a7d8dc82dd15c71e18cf520b75a271cecb2fe000d9814aec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "806649c794dd1bc947c28d5218085ddc046c1f6fccc4a1f875cedbd27f2269af"
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