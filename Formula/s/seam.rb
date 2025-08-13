class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.61.tgz"
  sha256 "64135eb8de1ddbc5190379088a34f87927b2e803a9bb71ce47cf1d873b1d94a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73fc65ba9659f60bf6423d9ddf462bd1be7c28918be7b1a716880e0252d9850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73fc65ba9659f60bf6423d9ddf462bd1be7c28918be7b1a716880e0252d9850"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73fc65ba9659f60bf6423d9ddf462bd1be7c28918be7b1a716880e0252d9850"
    sha256 cellar: :any_skip_relocation, sonoma:        "1646ba540816ebdab927fa8218f973bea1de92c19c85a3c9407610e09e29c5b9"
    sha256 cellar: :any_skip_relocation, ventura:       "1646ba540816ebdab927fa8218f973bea1de92c19c85a3c9407610e09e29c5b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f73fc65ba9659f60bf6423d9ddf462bd1be7c28918be7b1a716880e0252d9850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73fc65ba9659f60bf6423d9ddf462bd1be7c28918be7b1a716880e0252d9850"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end