class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.13.tgz"
  sha256 "7ff254329165df82a27e85bc58547a500481016ed4758f7f2eaab49208385554"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d8cd56854d6ee8038eec42f86dd91a500c158e5220d50564af852b3b7c2fbbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8cd56854d6ee8038eec42f86dd91a500c158e5220d50564af852b3b7c2fbbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d8cd56854d6ee8038eec42f86dd91a500c158e5220d50564af852b3b7c2fbbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b3811259e687b6e8099f5f6e4b2e58ee283f3ae4b366a70fd4c0f616e63b105"
    sha256 cellar: :any_skip_relocation, ventura:       "2b3811259e687b6e8099f5f6e4b2e58ee283f3ae4b366a70fd4c0f616e63b105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8cd56854d6ee8038eec42f86dd91a500c158e5220d50564af852b3b7c2fbbd"
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