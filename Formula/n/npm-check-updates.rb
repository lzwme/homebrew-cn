class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-18.0.0.tgz"
  sha256 "5fba0d2eb48dda11d8eb326c01607d29933916e81b2e9304e942d35ea2fc7e72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dacdd8a71e1acab1a0143ffbf38273587f48e381ff42a0e44b06b8e6fc654bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dacdd8a71e1acab1a0143ffbf38273587f48e381ff42a0e44b06b8e6fc654bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dacdd8a71e1acab1a0143ffbf38273587f48e381ff42a0e44b06b8e6fc654bd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e661cbfcd1f5639f8d5b6fe456477e3312d296e958a86b185ce980049ac2e09c"
    sha256 cellar: :any_skip_relocation, ventura:       "e661cbfcd1f5639f8d5b6fe456477e3312d296e958a86b185ce980049ac2e09c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacdd8a71e1acab1a0143ffbf38273587f48e381ff42a0e44b06b8e6fc654bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dacdd8a71e1acab1a0143ffbf38273587f48e381ff42a0e44b06b8e6fc654bd8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    test_package_json = testpath"package.json"
    test_package_json.write <<~JSON
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    JSON

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