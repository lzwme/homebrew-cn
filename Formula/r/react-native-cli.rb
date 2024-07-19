require "language/node"

class ReactNativeCli < Formula
  desc "Tools for creating native apps for Android and iOS"
  homepage "https://facebook.github.io/react-native/"
  url "https://registry.npmjs.org/react-native-cli/-/react-native-cli-2.0.1.tgz"
  sha256 "f1039232c86c29fa0b0c85ad2bfe0ff455c3d3cd9af9d9ddb8e9c560231a8322"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "294bd06227f8bc38e2adbfd14149c885304c4668dcff70a8528f256429dc66ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "294bd06227f8bc38e2adbfd14149c885304c4668dcff70a8528f256429dc66ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "294bd06227f8bc38e2adbfd14149c885304c4668dcff70a8528f256429dc66ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "294bd06227f8bc38e2adbfd14149c885304c4668dcff70a8528f256429dc66ea"
    sha256 cellar: :any_skip_relocation, ventura:        "294bd06227f8bc38e2adbfd14149c885304c4668dcff70a8528f256429dc66ea"
    sha256 cellar: :any_skip_relocation, monterey:       "294bd06227f8bc38e2adbfd14149c885304c4668dcff70a8528f256429dc66ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d3f103253c4aca89a6f814ddf314f87800185d0039be2878e9e3645c825c15"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/react-native init test --version=react-native@0.59.x")
    assert_match "Run instructions for Android", output
  end
end