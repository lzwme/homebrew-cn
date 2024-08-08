class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.0.5.tgz"
  sha256 "4c650388fe860b0e8f184140fd4457dee73702778937baccce56066f91f508c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9ef3bd75c0446b8d9a99dc7ca35f6876ccacbdbfeb3c04ce0af9320717932d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9ef3bd75c0446b8d9a99dc7ca35f6876ccacbdbfeb3c04ce0af9320717932d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9ef3bd75c0446b8d9a99dc7ca35f6876ccacbdbfeb3c04ce0af9320717932d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "05f592b6b0ce58b854452f61219b67d811f845abd989abf1c337f009e7d5ddcf"
    sha256 cellar: :any_skip_relocation, ventura:        "05f592b6b0ce58b854452f61219b67d811f845abd989abf1c337f009e7d5ddcf"
    sha256 cellar: :any_skip_relocation, monterey:       "05f592b6b0ce58b854452f61219b67d811f845abd989abf1c337f009e7d5ddcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aca9aa663f7e94006860c2406b7e6dcb7f915864713088d67ba638c66e11510"
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