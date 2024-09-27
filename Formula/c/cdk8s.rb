class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.228.tgz"
  sha256 "7d4f9bdac0b2340bd31d7c94ad6a83ac6f0f2eebd27699dec5c3316cee55604f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa29c1c0da4dc01bec9bc3487453ec0b35d349f90773fc96067d0ff0a6851618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa29c1c0da4dc01bec9bc3487453ec0b35d349f90773fc96067d0ff0a6851618"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa29c1c0da4dc01bec9bc3487453ec0b35d349f90773fc96067d0ff0a6851618"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ef13f8a20621432c85222ff21af2ef60662ca981b63833653a26337ea9a728"
    sha256 cellar: :any_skip_relocation, ventura:       "e8ef13f8a20621432c85222ff21af2ef60662ca981b63833653a26337ea9a728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa29c1c0da4dc01bec9bc3487453ec0b35d349f90773fc96067d0ff0a6851618"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end