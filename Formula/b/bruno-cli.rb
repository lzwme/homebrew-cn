class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-1.39.0.tgz"
  sha256 "a16a88c2ac52018f13b58a891befa0372c210409461812d9b489b284f80be13b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "807cf3fcd63832850c5a6622b95329be4301e94b1cf34c6221f4edbf87260194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "807cf3fcd63832850c5a6622b95329be4301e94b1cf34c6221f4edbf87260194"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "807cf3fcd63832850c5a6622b95329be4301e94b1cf34c6221f4edbf87260194"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd8b9f0f90b719146617e9c397451bcc07d39a4dfe51fdd60bbfb8d9fddf839"
    sha256 cellar: :any_skip_relocation, ventura:       "3dd8b9f0f90b719146617e9c397451bcc07d39a4dfe51fdd60bbfb8d9fddf839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807cf3fcd63832850c5a6622b95329be4301e94b1cf34c6221f4edbf87260194"
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