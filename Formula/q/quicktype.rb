require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.103.tgz"
  sha256 "73f861143edcea136600df2006539cb7040c54af7bbffd3fc5c33838f898fbb5"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32e7fec82294aacdcd3bf0023074df411203c816d9cb46bfef762d8184129173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32e7fec82294aacdcd3bf0023074df411203c816d9cb46bfef762d8184129173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32e7fec82294aacdcd3bf0023074df411203c816d9cb46bfef762d8184129173"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e66fc2ece65981bdc93d604a1f5250b4ca8a77d969838800802dc4f773aa782"
    sha256 cellar: :any_skip_relocation, ventura:        "9e66fc2ece65981bdc93d604a1f5250b4ca8a77d969838800802dc4f773aa782"
    sha256 cellar: :any_skip_relocation, monterey:       "9e66fc2ece65981bdc93d604a1f5250b4ca8a77d969838800802dc4f773aa782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e7fec82294aacdcd3bf0023074df411203c816d9cb46bfef762d8184129173"
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