class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.11.tgz"
  sha256 "42618c93f913f3bea23be404dc1d16eb01751dec818da64b9a2a4aa97163f414"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ecbc5d91909942121ed0553b6ac2b09e7bc69ab318792d1c80611af3e43e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ecbc5d91909942121ed0553b6ac2b09e7bc69ab318792d1c80611af3e43e23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0ecbc5d91909942121ed0553b6ac2b09e7bc69ab318792d1c80611af3e43e23"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f214e48a249fb4a240d5c5109441ec8dbc6f7c734cabd10421f0ea51ac43d39"
    sha256 cellar: :any_skip_relocation, ventura:       "2f214e48a249fb4a240d5c5109441ec8dbc6f7c734cabd10421f0ea51ac43d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ecbc5d91909942121ed0553b6ac2b09e7bc69ab318792d1c80611af3e43e23"
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