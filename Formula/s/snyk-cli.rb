require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1269.0.tgz"
  sha256 "21025870f652519821ad69949fa22de4720c220c184d4ada909a6ce0f20d4908"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "477958ba7eea96ffc97690d7c240cf5db31efcd1aaa4cdf0a2c8a6c07a15ebf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fde5f41c172a6a9dc86aa224e42208b712c39bc3d3992b57d3ba2978e062f598"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44645fa9056fa5bee3f396c64f097944fd08c6056cbd6ea2b3ac846a00303a2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "118a9849ce35efd55f08f9e672961dd0f6afc0e0f72d9d844098243808353ce5"
    sha256 cellar: :any_skip_relocation, ventura:        "b45a4fb79d6fdfe9f8045fd8e1d0564eb8f917c0a9ccab69283d8db0ec427ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb27119cb43de8ddacee296c6141eab534d652cd17f07032b5a04cb2be562ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802f384223bc805df01c43a379bd5bccbeb48a0c9e5568255f696fe0135c6c33"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end