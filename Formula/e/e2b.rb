class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.9.0.tgz"
  sha256 "b41b6793cc42756f6e68973b94b6d004f0047db36db26201912aa7eda4d19717"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da644846ab06063b88c443fabca8cc5d5307aef623a793df88a63bd8cb9567b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da644846ab06063b88c443fabca8cc5d5307aef623a793df88a63bd8cb9567b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da644846ab06063b88c443fabca8cc5d5307aef623a793df88a63bd8cb9567b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e8d0900b7e33523b16b4c7c0ebc24f6b489816ca07e999ccf52c91d6cd1c50"
    sha256 cellar: :any_skip_relocation, ventura:       "39e8d0900b7e33523b16b4c7c0ebc24f6b489816ca07e999ccf52c91d6cd1c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da644846ab06063b88c443fabca8cc5d5307aef623a793df88a63bd8cb9567b7"
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