require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.162.tgz"
  sha256 "7c3de0cbc40b4595dc8ad5ab50abf594fc14ae75b373a52cc304887f185d53a4"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75cd672efded588222cc40e14d21bfa3519fa42596ba86401ad583a9e7abbce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d037d5abe2b911d2ef53a4228cac838be8924bd608697632e4bbbd881ecddc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b829b3384e056c3420c0fc850c1027c50dce87c9ef5927c028c1d571bba8c16"
    sha256 cellar: :any_skip_relocation, sonoma:         "5edf8ae8efac6f3a9cd5b3575a57e785dd099ac5afc5384acb991979faf144cb"
    sha256 cellar: :any_skip_relocation, ventura:        "badc6b0d83308756a9aed9aa5fb4758d2969b92631631c5184075b97ad897ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "dae43a38d21351798e53cd75cc57e49e8853d81120ebebe5dc43a791181d3344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d48583b19b0f9253bf89f961e412926dc94756306f4e367b81ae57f9920cae2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end