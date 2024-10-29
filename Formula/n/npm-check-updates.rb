class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.9.tgz"
  sha256 "686987e8066d2173e36f21cc374efd60b012fd9f981d31cb5f2dc19e29d3353b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4fa5542a019f0ed5fc0235875cbf5d10d40aebe199fabe14c428a7b715c2528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4fa5542a019f0ed5fc0235875cbf5d10d40aebe199fabe14c428a7b715c2528"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4fa5542a019f0ed5fc0235875cbf5d10d40aebe199fabe14c428a7b715c2528"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecda0d095015df8fc2553e5bba08cdfa19fcb22bbcbb2871ad386f354e8aaeb3"
    sha256 cellar: :any_skip_relocation, ventura:       "ecda0d095015df8fc2553e5bba08cdfa19fcb22bbcbb2871ad386f354e8aaeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4fa5542a019f0ed5fc0235875cbf5d10d40aebe199fabe14c428a7b715c2528"
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