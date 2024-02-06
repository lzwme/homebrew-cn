require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1277.0.tgz"
  sha256 "a0ad001c2c8057741d093c98b61fc77b48b3223dc16af44d2bc3f290f72f39aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "688decc7efea7a9e6101d7732036e548eb31ac75a1dad57f53ea3e6eadbbda52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39365e31b0adab3f78e002e7a47f571997697b9725579b4dd2138ac5294c39d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a29cac1eb2e6a103681e7867ee309a05073d9f0864b5450b673839cc51d43781"
    sha256 cellar: :any_skip_relocation, sonoma:         "737df4f3b6827b3e36e2565fa984abe89d4f51d45fc06db906c62d50e8219e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "e9fbf59926c3309ce8734f66145194175c0fa10dcd2f427133a8e8f753ff707f"
    sha256 cellar: :any_skip_relocation, monterey:       "2776710010b2e0fcc60634b90691c569c1c9c64a84373ab0d8752f381613c7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85a1df0b53b27158989f0489da35b07f459d68ef4585030b6af4fa1096156004"
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