class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.1.tgz"
  sha256 "5e64b41ca51a915dd584c05ba4cd4e00d449419d81537775b3fadfe840c24924"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37d68c93020ce8fa2605f1b7746e38de2286734d00e008b787b12d9df8e2ce15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d68c93020ce8fa2605f1b7746e38de2286734d00e008b787b12d9df8e2ce15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d68c93020ce8fa2605f1b7746e38de2286734d00e008b787b12d9df8e2ce15"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee23c3857ce6b8e15c7289df971d502deb255b23e2114dab045b6ab3a7e21ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "ee23c3857ce6b8e15c7289df971d502deb255b23e2114dab045b6ab3a7e21ecb"
    sha256 cellar: :any_skip_relocation, monterey:       "ee23c3857ce6b8e15c7289df971d502deb255b23e2114dab045b6ab3a7e21ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d68c93020ce8fa2605f1b7746e38de2286734d00e008b787b12d9df8e2ce15"
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