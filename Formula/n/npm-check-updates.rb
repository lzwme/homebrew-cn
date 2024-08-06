class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.0.3.tgz"
  sha256 "66a66c4fabe8258dc902aaaeb4f1a049c7750b50c5512ee328d2cc43726cf600"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38a8e856e3f597276a9960fa94a86ecc4c778da61a18f385f251fee16f2649ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38a8e856e3f597276a9960fa94a86ecc4c778da61a18f385f251fee16f2649ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a8e856e3f597276a9960fa94a86ecc4c778da61a18f385f251fee16f2649ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "317aac3fed80cd22790329741ede218b5238f012e0f093423658c0e21f58c5df"
    sha256 cellar: :any_skip_relocation, ventura:        "317aac3fed80cd22790329741ede218b5238f012e0f093423658c0e21f58c5df"
    sha256 cellar: :any_skip_relocation, monterey:       "317aac3fed80cd22790329741ede218b5238f012e0f093423658c0e21f58c5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a8e856e3f597276a9960fa94a86ecc4c778da61a18f385f251fee16f2649ee"
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