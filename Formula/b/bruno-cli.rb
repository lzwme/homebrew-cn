class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.9.0.tgz"
  sha256 "65beba9bdc4d79cdfe042ebe2d261d332d5cac949208451f4c51fdb195bd0bad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59158a16e5d3abaf3ae10643b3dfa73dfde2010bccfe31282b0f68cc55a6791a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59158a16e5d3abaf3ae10643b3dfa73dfde2010bccfe31282b0f68cc55a6791a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59158a16e5d3abaf3ae10643b3dfa73dfde2010bccfe31282b0f68cc55a6791a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4f73715eb06b6bae29a3ffb5b16f343cb95feac85036e6d3904a8e24767bc5"
    sha256 cellar: :any_skip_relocation, ventura:       "ac4f73715eb06b6bae29a3ffb5b16f343cb95feac85036e6d3904a8e24767bc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59158a16e5d3abaf3ae10643b3dfa73dfde2010bccfe31282b0f68cc55a6791a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59158a16e5d3abaf3ae10643b3dfa73dfde2010bccfe31282b0f68cc55a6791a"
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