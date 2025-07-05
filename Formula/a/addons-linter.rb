class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.16.0.tgz"
  sha256 "0269ac4c5a282653c4320893f554a9351615cfe74943a42e2e0f735724270ca2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74adcea8c9f2f651f24d62a2a95d78b0955986055f5f39af7b755ed669b3e580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74adcea8c9f2f651f24d62a2a95d78b0955986055f5f39af7b755ed669b3e580"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74adcea8c9f2f651f24d62a2a95d78b0955986055f5f39af7b755ed669b3e580"
    sha256 cellar: :any_skip_relocation, sonoma:        "4416bfb2071a8ad683a0a0335f5b9e833569f98b39eb24eb5856497e513db3ce"
    sha256 cellar: :any_skip_relocation, ventura:       "4416bfb2071a8ad683a0a0335f5b9e833569f98b39eb24eb5856497e513db3ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74adcea8c9f2f651f24d62a2a95d78b0955986055f5f39af7b755ed669b3e580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74adcea8c9f2f651f24d62a2a95d78b0955986055f5f39af7b755ed669b3e580"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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