require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.168.tgz"
  sha256 "ce1a50600273da78ec1f0c92a5ac9026fd14bccc16360d102a2c4c8cb14a845b"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50607f7ad15580fc628ee1c921ea946a1744d8c1cca94c89c375110b87ccf13d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8af427c7201205b3c8b6fa61d34bb8a9a4c4987e4f153597e4199641602b16f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "292f9e9a68bd09ec7913f1a75791f746ad1bb5457e99630bd9219ce08d2eb772"
    sha256 cellar: :any_skip_relocation, sonoma:         "d341c2feafb3e82d776ce67b4efb871f7150b9b4c7a31fa218acf7ca1c7142bb"
    sha256 cellar: :any_skip_relocation, ventura:        "4252ab6685685a6b0e277ecb29e44d458f42b14e649b5bbddd752426011ce65c"
    sha256 cellar: :any_skip_relocation, monterey:       "861e4ec24a8b79be76554eadaf89231b77a867bb0b8c4f402e3d343cadf8b62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2338ce6156cbbab1d238308dfd6e509cd139e5ca2a936cdd7b0c437e333f050"
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