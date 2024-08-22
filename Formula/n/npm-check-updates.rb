class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.0.tgz"
  sha256 "43280165b3a0e2907f5bf01468a5f5bf307ec31f12050ca57a844d86dd7c6404"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "767b866e7c17ac98607ccb28a51ea9b1f7abc77df3df806d3615a182a64efe82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "767b866e7c17ac98607ccb28a51ea9b1f7abc77df3df806d3615a182a64efe82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767b866e7c17ac98607ccb28a51ea9b1f7abc77df3df806d3615a182a64efe82"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0db07f5671885f15eb39d37fb5e0e7c8d65417f5fbda03e94b11920444847c8"
    sha256 cellar: :any_skip_relocation, ventura:        "b0db07f5671885f15eb39d37fb5e0e7c8d65417f5fbda03e94b11920444847c8"
    sha256 cellar: :any_skip_relocation, monterey:       "b0db07f5671885f15eb39d37fb5e0e7c8d65417f5fbda03e94b11920444847c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767b866e7c17ac98607ccb28a51ea9b1f7abc77df3df806d3615a182a64efe82"
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