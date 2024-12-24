class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.11.0.tgz"
  sha256 "077e489ad95d3f4f0fc32ff0d1cac1c659c7a31cec5b5365b0fb31a62a142222"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76829244c66709da679d59b077453f64b171cdef6ba55ad89d72389e61f526f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76829244c66709da679d59b077453f64b171cdef6ba55ad89d72389e61f526f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76829244c66709da679d59b077453f64b171cdef6ba55ad89d72389e61f526f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3201f7ac1cfe56f8fcbd4005aea26bf94b0344b1a4a755a33c74f61a5d950f"
    sha256 cellar: :any_skip_relocation, ventura:       "0f3201f7ac1cfe56f8fcbd4005aea26bf94b0344b1a4a755a33c74f61a5d950f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76829244c66709da679d59b077453f64b171cdef6ba55ad89d72389e61f526f6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}release-it -v")
    (testpath"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)m,
      shell_output("#{bin}release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath"package.json").read
  end
end