class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comglideappsquicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.1.0.tgz"
  sha256 "9ae88335d255afbe40206a4b51bac998c966208aa51f8ba5d35f707769b74641"
  license "Apache-2.0"
  head "https:github.comglideappsquicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f22d6ffd01470e68048c163bbebcd19b1a12d6b070f63f3c5c735b02977dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f22d6ffd01470e68048c163bbebcd19b1a12d6b070f63f3c5c735b02977dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f22d6ffd01470e68048c163bbebcd19b1a12d6b070f63f3c5c735b02977dbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0811c1ad66fb38d755d155ff6223e672c88d3db9a45af2bb5c37fb74fff5ce"
    sha256 cellar: :any_skip_relocation, ventura:       "ae0811c1ad66fb38d755d155ff6223e672c88d3db9a45af2bb5c37fb74fff5ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f22d6ffd01470e68048c163bbebcd19b1a12d6b070f63f3c5c735b02977dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f22d6ffd01470e68048c163bbebcd19b1a12d6b070f63f3c5c735b02977dbc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end