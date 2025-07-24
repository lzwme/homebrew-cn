class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-18.0.2.tgz"
  sha256 "6030b0e96c51bc762116f3b9a2401d9162f3d6a20cd51f05ef68a22e2caa3e9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1c99ce0b2f4c07609d9c499883ee93710bf30f020f350634579337584fe035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd1c99ce0b2f4c07609d9c499883ee93710bf30f020f350634579337584fe035"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd1c99ce0b2f4c07609d9c499883ee93710bf30f020f350634579337584fe035"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb90b2b8716d21c255eec8557abe64d992f4e0c59957ab29ea6afd0e478b8e2"
    sha256 cellar: :any_skip_relocation, ventura:       "ebb90b2b8716d21c255eec8557abe64d992f4e0c59957ab29ea6afd0e478b8e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd1c99ce0b2f4c07609d9c499883ee93710bf30f020f350634579337584fe035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1c99ce0b2f4c07609d9c499883ee93710bf30f020f350634579337584fe035"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~JSON
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    JSON

    system bin/"ncu", "-u"

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