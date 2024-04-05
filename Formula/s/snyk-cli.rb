require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1287.0.tgz"
  sha256 "c56be1a5e4247115875539b8d32fe8bd64b386f9357faaad70f9cf70590424d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ba6e56b11dac4bc7e15d065ba56111b77a1b3cd7dd37acd8e9571d2fdad550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5171abee1f8833690176164dcb3b9931ddc71cc6ff2000a1241183734ab5fd7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39814a8acf491fbc7c128afea78b7087b1f1207fd22dd21e686fbc2e5bfbed9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b12a0bf8a26e8b98a24c248b5ddaa4206e0f622dc7613d24d40736c3e1d9fcf1"
    sha256 cellar: :any_skip_relocation, ventura:        "35dd7f4e3a5666e920a52725e72f5e8ef772e1b01f21f89f7bb0d48527fcb233"
    sha256 cellar: :any_skip_relocation, monterey:       "06c5ffd87df1b8728b408020c3e2eaf885e05cf7cb94193dd00bdf4404eedbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ca688bfd73439fa6d27acf2d34efaab66c4f259a31ee6e5afc6480819c6ded"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end