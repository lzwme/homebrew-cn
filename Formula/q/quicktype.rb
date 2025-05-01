class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comglideappsquicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.1.2.tgz"
  sha256 "0924e180725c6ea5176ad2f45cc1931e5f9bf789118236ccc7325fcd6b4e4ead"
  license "Apache-2.0"
  head "https:github.comglideappsquicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166cc3481611be27e5e0d10fe6af649b19f2223c164042a219d805f9348d546d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "166cc3481611be27e5e0d10fe6af649b19f2223c164042a219d805f9348d546d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "166cc3481611be27e5e0d10fe6af649b19f2223c164042a219d805f9348d546d"
    sha256 cellar: :any_skip_relocation, sonoma:        "393c69612a45606718103871b2e648089d6d0154831fdeb605808755bb8cf571"
    sha256 cellar: :any_skip_relocation, ventura:       "393c69612a45606718103871b2e648089d6d0154831fdeb605808755bb8cf571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166cc3481611be27e5e0d10fe6af649b19f2223c164042a219d805f9348d546d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "166cc3481611be27e5e0d10fe6af649b19f2223c164042a219d805f9348d546d"
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