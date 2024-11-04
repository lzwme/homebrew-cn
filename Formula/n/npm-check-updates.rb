class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.10.tgz"
  sha256 "a5aad14ede0b60cf5509784d90339c47d942b64563718c70ceb180d239ee986c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a08c4a5eb812c66ab0b16c3960acf4b5461651441b4aff8c326afbcc53e4ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a08c4a5eb812c66ab0b16c3960acf4b5461651441b4aff8c326afbcc53e4ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a08c4a5eb812c66ab0b16c3960acf4b5461651441b4aff8c326afbcc53e4ec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "15294339aa4046a2d3b9dbda51bd2767353e883c81e561014899338c5d520f13"
    sha256 cellar: :any_skip_relocation, ventura:       "15294339aa4046a2d3b9dbda51bd2767353e883c81e561014899338c5d520f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a08c4a5eb812c66ab0b16c3960acf4b5461651441b4aff8c326afbcc53e4ec8"
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