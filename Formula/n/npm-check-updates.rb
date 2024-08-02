class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.0.0.tgz"
  sha256 "7465072fb47059068f862cb9210b206a43e294e6b3841d19bd1cee86b3270216"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ba1d6d3d33b75f59c891adaca70f31f61976fc3528b17e1bc18b699ce058930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba1d6d3d33b75f59c891adaca70f31f61976fc3528b17e1bc18b699ce058930"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ba1d6d3d33b75f59c891adaca70f31f61976fc3528b17e1bc18b699ce058930"
    sha256 cellar: :any_skip_relocation, sonoma:         "21fa8b29f3157b6fc360947d4c7e3c33691cb5d602423ec2fdd18c4851c7b67c"
    sha256 cellar: :any_skip_relocation, ventura:        "21fa8b29f3157b6fc360947d4c7e3c33691cb5d602423ec2fdd18c4851c7b67c"
    sha256 cellar: :any_skip_relocation, monterey:       "21fa8b29f3157b6fc360947d4c7e3c33691cb5d602423ec2fdd18c4851c7b67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008b77d2deac7f4ebedf7b76b2c83e7db29334c077de0fae4ab64811aa7ee2f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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