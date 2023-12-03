require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.80.tgz"
  sha256 "5a26c7561ea8211e5ccafa2cf8f195c933bf5c26eb4dc0f284043d8cc1722659"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1aa44a2869233c9afd9595dd7a315d262725e6b1fe16b61b3e90e12d26058807"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aa44a2869233c9afd9595dd7a315d262725e6b1fe16b61b3e90e12d26058807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aa44a2869233c9afd9595dd7a315d262725e6b1fe16b61b3e90e12d26058807"
    sha256 cellar: :any_skip_relocation, sonoma:         "490bc7336b1a0530308e52e8585bbda5f76b7d596e97925cace4b365350061b2"
    sha256 cellar: :any_skip_relocation, ventura:        "490bc7336b1a0530308e52e8585bbda5f76b7d596e97925cace4b365350061b2"
    sha256 cellar: :any_skip_relocation, monterey:       "490bc7336b1a0530308e52e8585bbda5f76b7d596e97925cace4b365350061b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa44a2869233c9afd9595dd7a315d262725e6b1fe16b61b3e90e12d26058807"
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