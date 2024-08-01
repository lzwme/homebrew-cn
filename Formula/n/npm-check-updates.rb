require "languagenode"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.0.0.tgz"
  sha256 "7465072fb47059068f862cb9210b206a43e294e6b3841d19bd1cee86b3270216"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec7ac0020a9eea33120a7296b6dda7589c4375cdbd5d140069e72d98b02ae300"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec7ac0020a9eea33120a7296b6dda7589c4375cdbd5d140069e72d98b02ae300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7ac0020a9eea33120a7296b6dda7589c4375cdbd5d140069e72d98b02ae300"
    sha256 cellar: :any_skip_relocation, sonoma:         "8488a6ccc485be2af85dfcfb09848c59ace446e4d5b70413904d620bd5effbbe"
    sha256 cellar: :any_skip_relocation, ventura:        "8488a6ccc485be2af85dfcfb09848c59ace446e4d5b70413904d620bd5effbbe"
    sha256 cellar: :any_skip_relocation, monterey:       "8488a6ccc485be2af85dfcfb09848c59ace446e4d5b70413904d620bd5effbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b573f7c80dbd03ff313a996d4e1cdc2caee9283828f342a3587fc7fe7324f409"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    test_package_json = testpath"package.json"
    test_package_json.write <<~EOS
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    EOS

    system bin"ncu", "-u"

    # Read the updated package.json to get the new dependency versions
    updated_package_json = JSON.parse(test_package_json.read)
    updated_express_version = updated_package_json["dependencies"]["express"]
    updated_lodash_version = updated_package_json["dependencies"]["lodash"]

    # Assert that both dependencies have been updated to higher versions
    assert Gem::Version.new(updated_express_version) > Gem::Version.new("1.8.7"),
      "Express version not updated as expected"
    assert Gem::Version.new(updated_lodash_version) > Gem::Version.new("3.6.1"),
      "Lodash version not updated as expected"
  end
end