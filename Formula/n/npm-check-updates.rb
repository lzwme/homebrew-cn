class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.0.2.tgz"
  sha256 "33c6fcfa6f4bf81795736671f3c59381f01a299f0ca570b722829d52c3e40835"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aba5e89007baee48f8e7d5ed66a7f931d43281d3ed814dd02262e4c6414f2cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba5e89007baee48f8e7d5ed66a7f931d43281d3ed814dd02262e4c6414f2cba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba5e89007baee48f8e7d5ed66a7f931d43281d3ed814dd02262e4c6414f2cba"
    sha256 cellar: :any_skip_relocation, sonoma:         "42cc8e1094fd5a1c03c0c4ca05cb29494bb4edd7ea07a81af9911298e250f082"
    sha256 cellar: :any_skip_relocation, ventura:        "42cc8e1094fd5a1c03c0c4ca05cb29494bb4edd7ea07a81af9911298e250f082"
    sha256 cellar: :any_skip_relocation, monterey:       "42cc8e1094fd5a1c03c0c4ca05cb29494bb4edd7ea07a81af9911298e250f082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba5e89007baee48f8e7d5ed66a7f931d43281d3ed814dd02262e4c6414f2cba"
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