require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.4.0.tgz"
  sha256 "0fa76bb05753b63b92d6f4b657fdced0e94ef543a079560c970451a318d1e35a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f776329a65045a559679a1dd7175749e9e92b192de715b01605bdcd6f91ff038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f776329a65045a559679a1dd7175749e9e92b192de715b01605bdcd6f91ff038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f776329a65045a559679a1dd7175749e9e92b192de715b01605bdcd6f91ff038"
    sha256 cellar: :any_skip_relocation, ventura:        "4129604399ed5937196b0c55644116e05820d7a18084857f8d231af95de35ff2"
    sha256 cellar: :any_skip_relocation, monterey:       "4129604399ed5937196b0c55644116e05820d7a18084857f8d231af95de35ff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4129604399ed5937196b0c55644116e05820d7a18084857f8d231af95de35ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f776329a65045a559679a1dd7175749e9e92b192de715b01605bdcd6f91ff038"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end