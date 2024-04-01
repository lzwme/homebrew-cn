require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.115.tgz"
  sha256 "94b3ac8b27da755d6cb84c953627196f1ff3c771112b689c3b6605b9852dc6a2"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
    sha256 cellar: :any_skip_relocation, sonoma:         "40be35c9e000402217f118cf14ed8d345ecfdf3ca74569875f08eee614c38f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "40be35c9e000402217f118cf14ed8d345ecfdf3ca74569875f08eee614c38f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "40be35c9e000402217f118cf14ed8d345ecfdf3ca74569875f08eee614c38f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
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