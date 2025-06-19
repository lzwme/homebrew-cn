class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.5.1.tgz"
  sha256 "e9f2b9ba395da1fbc93bc3fa583fb52cc2447632001a47f8810bb16cb56099bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93719be97b6101a6673a7c3eef09974f4ce0026692a0849182f2490234355133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93719be97b6101a6673a7c3eef09974f4ce0026692a0849182f2490234355133"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93719be97b6101a6673a7c3eef09974f4ce0026692a0849182f2490234355133"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4822c8dc891a751e7a621e30e0f24a5bf65c34a019e243a2a1fcfcb01a555f"
    sha256 cellar: :any_skip_relocation, ventura:       "fd4822c8dc891a751e7a621e30e0f24a5bf65c34a019e243a2a1fcfcb01a555f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93719be97b6101a6673a7c3eef09974f4ce0026692a0849182f2490234355133"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end