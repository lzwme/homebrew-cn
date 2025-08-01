class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.19.0.tgz"
  sha256 "d31c6c10efdd0c8a12759a5438176cbf093847cd0c36eec48885e6a88991cbc9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4da743852e397cb013cf499471e0188a50d59e1d0c3975ccaa7a596be91e950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4da743852e397cb013cf499471e0188a50d59e1d0c3975ccaa7a596be91e950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4da743852e397cb013cf499471e0188a50d59e1d0c3975ccaa7a596be91e950"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f792292339dce159a28b8dc3eda5c93ffb3922a7eeec5284b9de4982e124c7"
    sha256 cellar: :any_skip_relocation, ventura:       "62f792292339dce159a28b8dc3eda5c93ffb3922a7eeec5284b9de4982e124c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4da743852e397cb013cf499471e0188a50d59e1d0c3975ccaa7a596be91e950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4da743852e397cb013cf499471e0188a50d59e1d0c3975ccaa7a596be91e950"
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