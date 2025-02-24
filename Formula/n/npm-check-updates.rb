class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.15.tgz"
  sha256 "4bbd011ec2a0c26f6105c6c2e7652e6f5674ab6324bf46aabdafbcd8dff88201"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e6065f8bb9d50aa175d8d9a4409414cf5f04c05fce96837283a474812a94fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e6065f8bb9d50aa175d8d9a4409414cf5f04c05fce96837283a474812a94fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7e6065f8bb9d50aa175d8d9a4409414cf5f04c05fce96837283a474812a94fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4856b560bb049bca4ecc7195503c749abde1a579bb5f9ebd7aa7dafaefb10e3"
    sha256 cellar: :any_skip_relocation, ventura:       "e4856b560bb049bca4ecc7195503c749abde1a579bb5f9ebd7aa7dafaefb10e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e6065f8bb9d50aa175d8d9a4409414cf5f04c05fce96837283a474812a94fe"
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