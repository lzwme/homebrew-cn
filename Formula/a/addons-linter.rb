class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https:github.commozillaaddons-linter"
  url "https:registry.npmjs.orgaddons-linter-addons-linter-7.15.0.tgz"
  sha256 "1db441516017f2dc9d5f626211f41e935ba2f21a8a77fbe08e752e7ea1f9e8bb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef75198a14864c28a6e0acab3967aa0c380c261174bf6e821e5185bc27a7551f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef75198a14864c28a6e0acab3967aa0c380c261174bf6e821e5185bc27a7551f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef75198a14864c28a6e0acab3967aa0c380c261174bf6e821e5185bc27a7551f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7681f1bae238e71b92e1684b42e53dd6b7ce609a318c63518566be79035c8365"
    sha256 cellar: :any_skip_relocation, ventura:       "7681f1bae238e71b92e1684b42e53dd6b7ce609a318c63518566be79035c8365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef75198a14864c28a6e0acab3967aa0c380c261174bf6e821e5185bc27a7551f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef75198a14864c28a6e0acab3967aa0c380c261174bf6e821e5185bc27a7551f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}addons-linter --version")

    (testpath"manifest.json").write <<~JSON
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

    output = shell_output("#{bin}addons-linter #{testpath}manifest.json 2>&1")
    assert_match "BAD_ZIPFILE   Corrupt ZIP", output
  end
end