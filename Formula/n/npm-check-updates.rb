class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.8.tgz"
  sha256 "d62f794d6cb90de94085f168d9a17551246ba41a0d91ceac779966f379636957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "375d9de920e149669081a218e63edf18a6b85ae1ca405d597beec28abf115fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375d9de920e149669081a218e63edf18a6b85ae1ca405d597beec28abf115fb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "375d9de920e149669081a218e63edf18a6b85ae1ca405d597beec28abf115fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c829de696da2ab6d5bd5b7ba1c40cb33bd9e89c3a2a83d5ee41e4e48c755531d"
    sha256 cellar: :any_skip_relocation, ventura:       "c829de696da2ab6d5bd5b7ba1c40cb33bd9e89c3a2a83d5ee41e4e48c755531d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "375d9de920e149669081a218e63edf18a6b85ae1ca405d597beec28abf115fb5"
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