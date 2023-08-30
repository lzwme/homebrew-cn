require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.73.tgz"
  sha256 "bb6aa7f80ca951d64f500a935cb7692641875f401ad60a4a37a4901aaf86fef8"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7077115ac36b0459b215c688d53306f86e8e6bb65f6fef9c4c42f6ba7cbdb31b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7077115ac36b0459b215c688d53306f86e8e6bb65f6fef9c4c42f6ba7cbdb31b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7077115ac36b0459b215c688d53306f86e8e6bb65f6fef9c4c42f6ba7cbdb31b"
    sha256 cellar: :any_skip_relocation, ventura:        "00b23a1d0c01bf05c3d9373bac639f03b4a659b1898cb075cf52dc8b660d8e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "00b23a1d0c01bf05c3d9373bac639f03b4a659b1898cb075cf52dc8b660d8e0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b23a1d0c01bf05c3d9373bac639f03b4a659b1898cb075cf52dc8b660d8e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7077115ac36b0459b215c688d53306f86e8e6bb65f6fef9c4c42f6ba7cbdb31b"
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