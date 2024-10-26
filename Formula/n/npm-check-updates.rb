class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https:github.comraineorshinenpm-check-updates"
  url "https:registry.npmjs.orgnpm-check-updates-npm-check-updates-17.1.6.tgz"
  sha256 "39a29553f93091a8b9b33f52616f4e041c84eb476dad0f3db7c029ef5a01129a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf86b495f8eb08021eeb17a3b3e07a71eac6d81e84a3e49881f29b58de01cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf86b495f8eb08021eeb17a3b3e07a71eac6d81e84a3e49881f29b58de01cce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccf86b495f8eb08021eeb17a3b3e07a71eac6d81e84a3e49881f29b58de01cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "71b3563b2b1e2fa517c73558166c87f206d19eec28f0ec268e9925bc6b6de976"
    sha256 cellar: :any_skip_relocation, ventura:       "71b3563b2b1e2fa517c73558166c87f206d19eec28f0ec268e9925bc6b6de976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf86b495f8eb08021eeb17a3b3e07a71eac6d81e84a3e49881f29b58de01cce"
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