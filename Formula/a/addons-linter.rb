class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-9.5.0.tgz"
  sha256 "6863737ae4b7eb2f9192e9adf46327a8a7566a2a5816488b7f106a3a4d91b0dc"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64be5fa944aec99c9a819d8ea8d0613ed6e930ba2d50853025065f6bc5891fa7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/addons-linter --version")

    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "Test Addon",
        "version": "1.0",
        "description": "A test addon",
        "applications": {
          "gecko": {
            "id": "test-addon@example.com"
          }
        }
      }
    JSON
    output = shell_output("#{bin}/addons-linter #{testpath}/manifest.json 2>&1")
    assert_match "BAD_ZIPFILE   Corrupt ZIP", output
  end
end