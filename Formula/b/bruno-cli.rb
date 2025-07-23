class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.8.0.tgz"
  sha256 "5629658226f5aa8f0bc796278316240ca41213b6d2047360dfad97f623849a8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d4d665ceeeee691c0c3033b1ac5687d228c2234b6ddd910ad781c0ca7201538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4d665ceeeee691c0c3033b1ac5687d228c2234b6ddd910ad781c0ca7201538"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d4d665ceeeee691c0c3033b1ac5687d228c2234b6ddd910ad781c0ca7201538"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1127dbb25c4326965446e804cb98f5784314507ae9cca976fd9d5954e1057ae"
    sha256 cellar: :any_skip_relocation, ventura:       "c1127dbb25c4326965446e804cb98f5784314507ae9cca976fd9d5954e1057ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d4d665ceeeee691c0c3033b1ac5687d228c2234b6ddd910ad781c0ca7201538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d4d665ceeeee691c0c3033b1ac5687d228c2234b6ddd910ad781c0ca7201538"
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