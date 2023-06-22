require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.140.0.tgz"
  sha256 "2fd28c31f4a78e7b75519041013944bfc5fa617801f2060e767d3c8d870e816e"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b38784b8cd9ef89196cebe372a97abdf1c605d9e40435e051fee468099b33d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa29800660fffcdfeefb51d4d5879caf7671f19dd215a064658bcf6247cf4d16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a9adb7903229e0e483e07edfc825316a55a942dc585eff808901d64a17cb714"
    sha256 cellar: :any_skip_relocation, ventura:        "0c0910bbdd79c3bed2a13b8a89a3b1d7c69d981f975528ab456282cda4e0635d"
    sha256 cellar: :any_skip_relocation, monterey:       "02092804398f1c8957a34a5772002b3a4ed521ad4b3ac7957325c73663270613"
    sha256 cellar: :any_skip_relocation, big_sur:        "e77fccb1da2cf8d71574c3ecfaf96dc96de3b94e7d1b93e6dc3f494a46b1d680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80f2cde98cc6fe7db67cd63193ba52c24b3ed88435f36c421b56897558da3c0"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end