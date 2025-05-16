class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comglideappsquicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.2.0.tgz"
  sha256 "b6f257badbb64c56fca9e5a30a09d69ffd5927504ed443d0b291fcba0231a426"
  license "Apache-2.0"
  head "https:github.comglideappsquicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b540f285deddb6cf61cf81620c47288af3f4d8c6813eb65c84f50595845ff3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b540f285deddb6cf61cf81620c47288af3f4d8c6813eb65c84f50595845ff3fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b540f285deddb6cf61cf81620c47288af3f4d8c6813eb65c84f50595845ff3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09d0ad9d92a9b15984c28062b6b27cb5c10a4da489fedd0c3acad038a16459d"
    sha256 cellar: :any_skip_relocation, ventura:       "b09d0ad9d92a9b15984c28062b6b27cb5c10a4da489fedd0c3acad038a16459d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b540f285deddb6cf61cf81620c47288af3f4d8c6813eb65c84f50595845ff3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b540f285deddb6cf61cf81620c47288af3f4d8c6813eb65c84f50595845ff3fd"
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