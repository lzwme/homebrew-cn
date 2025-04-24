class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comglideappsquicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.172.tgz"
  sha256 "b2f8b1a691db5abf3cfd8d0cd5c2d43b0e778fab53d25423b5211afce016cc1d"
  license "Apache-2.0"
  head "https:github.comglideappsquicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b232d21c838d33967577d819959589c75616177b2bb19d5d85e97fc388ffda7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b232d21c838d33967577d819959589c75616177b2bb19d5d85e97fc388ffda7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b232d21c838d33967577d819959589c75616177b2bb19d5d85e97fc388ffda7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f2acb7e5c3e62ea27468e5d29cbea812be2a634d3275fb13ce8b3893f36279"
    sha256 cellar: :any_skip_relocation, ventura:       "37f2acb7e5c3e62ea27468e5d29cbea812be2a634d3275fb13ce8b3893f36279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b232d21c838d33967577d819959589c75616177b2bb19d5d85e97fc388ffda7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b232d21c838d33967577d819959589c75616177b2bb19d5d85e97fc388ffda7a"
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