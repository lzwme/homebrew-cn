class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https:github.commozillaaddons-linter"
  url "https:registry.npmjs.orgaddons-linter-addons-linter-7.14.0.tgz"
  sha256 "93b191e58f93af87ad69d87435119ec2e69e9fb6a52c6cf9befcb23462134ca6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181824134a21c3ee0a752121341004e28b82ce7e335ad3371046f024e99d23c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181824134a21c3ee0a752121341004e28b82ce7e335ad3371046f024e99d23c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "181824134a21c3ee0a752121341004e28b82ce7e335ad3371046f024e99d23c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba44725088f0528ce75f87e7a3227363b4f0b228983f0b2425fb7b86723cb218"
    sha256 cellar: :any_skip_relocation, ventura:       "ba44725088f0528ce75f87e7a3227363b4f0b228983f0b2425fb7b86723cb218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181824134a21c3ee0a752121341004e28b82ce7e335ad3371046f024e99d23c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181824134a21c3ee0a752121341004e28b82ce7e335ad3371046f024e99d23c7"
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