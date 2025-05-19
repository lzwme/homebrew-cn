class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comglideappsquicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.2.5.tgz"
  sha256 "ec650d3904d4c16e3aee13b0611db6ff9d4a4ce68cb3d2294981eda75107b2dd"
  license "Apache-2.0"
  head "https:github.comglideappsquicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d68008fee1d99baac3702fae5970afdfe3c0fa057ee9d19dcac3a69da706b42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d68008fee1d99baac3702fae5970afdfe3c0fa057ee9d19dcac3a69da706b42c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d68008fee1d99baac3702fae5970afdfe3c0fa057ee9d19dcac3a69da706b42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94df8b2f8272717605e8c0b649cc1c275c5d3cfda17c52e84b2fc96faf26ed18"
    sha256 cellar: :any_skip_relocation, ventura:       "94df8b2f8272717605e8c0b649cc1c275c5d3cfda17c52e84b2fc96faf26ed18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d68008fee1d99baac3702fae5970afdfe3c0fa057ee9d19dcac3a69da706b42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68008fee1d99baac3702fae5970afdfe3c0fa057ee9d19dcac3a69da706b42c"
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