class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.0.1.tgz"
  sha256 "b0ce26b3e30db9280ad9c3ab530758e404a8db7398476ebc01939ff25d6d0ad4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3b80bffd1abb662399c0baea38a1c0d4f1f53117bef21ddc33252e3718c7eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3b80bffd1abb662399c0baea38a1c0d4f1f53117bef21ddc33252e3718c7eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3b80bffd1abb662399c0baea38a1c0d4f1f53117bef21ddc33252e3718c7eeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bc744e2ce83332e7dde8973cd58c5f20f7a174dece2750c3a59fab96396f25d"
    sha256 cellar: :any_skip_relocation, ventura:        "1bc744e2ce83332e7dde8973cd58c5f20f7a174dece2750c3a59fab96396f25d"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc744e2ce83332e7dde8973cd58c5f20f7a174dece2750c3a59fab96396f25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b80bffd1abb662399c0baea38a1c0d4f1f53117bef21ddc33252e3718c7eeb"
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