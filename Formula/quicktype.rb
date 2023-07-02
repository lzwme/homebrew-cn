require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.49.tgz"
  sha256 "f1d3728290d8c27cdc087497235ff039665d21369a7a522ddc7469b589155ce5"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bced00aade5cdf417bc7258bd52f38e836c49ee904aae0af4d37d49c7bffdf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bced00aade5cdf417bc7258bd52f38e836c49ee904aae0af4d37d49c7bffdf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bced00aade5cdf417bc7258bd52f38e836c49ee904aae0af4d37d49c7bffdf4"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb3d828bfa6f7fdb496fdb65d1564645da830dcf7762871d3f59f6ee9e66592"
    sha256 cellar: :any_skip_relocation, monterey:       "ddb3d828bfa6f7fdb496fdb65d1564645da830dcf7762871d3f59f6ee9e66592"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddb3d828bfa6f7fdb496fdb65d1564645da830dcf7762871d3f59f6ee9e66592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bced00aade5cdf417bc7258bd52f38e836c49ee904aae0af4d37d49c7bffdf4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end