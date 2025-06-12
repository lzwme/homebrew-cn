class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-2.5.0.tgz"
  sha256 "4f07cd0075c389a9f082d0c9ada79d2dd27cf89f41d8f21a25fa363ae9ba4807"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9229d0ecd558e2645d160cf3553a17f8616042ef697fa71668a7245ceb2cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb9229d0ecd558e2645d160cf3553a17f8616042ef697fa71668a7245ceb2cdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb9229d0ecd558e2645d160cf3553a17f8616042ef697fa71668a7245ceb2cdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "13875e50877af8a3bcd70e39fbe45f8baec68bd3db71163ccef6e0506a869b05"
    sha256 cellar: :any_skip_relocation, ventura:       "13875e50877af8a3bcd70e39fbe45f8baec68bd3db71163ccef6e0506a869b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9229d0ecd558e2645d160cf3553a17f8616042ef697fa71668a7245ceb2cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb9229d0ecd558e2645d160cf3553a17f8616042ef697fa71668a7245ceb2cdd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https:github.comusebrunobrunoissues2229
    (bin"bru").write_env_script libexec"binbru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}bru run 2>&1", 4)
  end
end