require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.35.tgz"
  sha256 "950227040e5050b6d58c6c75422b142a67be631d12dd4bb101c82a0012012fef"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e40ad3cbe656b5670f40db898379bddaf655afeba689390f1ed1e3389998079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e40ad3cbe656b5670f40db898379bddaf655afeba689390f1ed1e3389998079"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e40ad3cbe656b5670f40db898379bddaf655afeba689390f1ed1e3389998079"
    sha256 cellar: :any_skip_relocation, ventura:        "73ffbde4fc71833632028b06632d58ff9d832cb2f695e622ab24d556fe11f318"
    sha256 cellar: :any_skip_relocation, monterey:       "73ffbde4fc71833632028b06632d58ff9d832cb2f695e622ab24d556fe11f318"
    sha256 cellar: :any_skip_relocation, big_sur:        "73ffbde4fc71833632028b06632d58ff9d832cb2f695e622ab24d556fe11f318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e40ad3cbe656b5670f40db898379bddaf655afeba689390f1ed1e3389998079"
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