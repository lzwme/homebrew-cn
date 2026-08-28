class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.35.0.tgz"
  sha256 "ce658757cbeb9242eb7abe20769775a66973ba3a0554f0bee282a45b58e84f4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb59575ac6da49c2799014ecde134d11610fc66cee013abf5161be2fc1569285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c89f236b5eac786657c1f1318592b2caf0af6a63ef70570be08af3f54bc3510c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df56c101fb99e87a8a86ccc136cb82883eaa9ed224ad24b9964fcc6cba5db21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17da7c03ec95e48f7121e49c3643c51b07e072ea60863f9f4f324e62f42e24d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e97016d0ddb93a6f9dbe3e957f235ee74d5e72529e1da395bdb7fefaf3bdbd"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@anthropic-ai` packages
    # which uses proprietary license.
    (libexec/"seam").install buildpath.children
    cd libexec/"seam" do
      system "npm", "install", "--omit=optional", "--omit=dev", *std_npm_args(prefix: false)
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable bin/"seam",
                                         "completion",
                                         "--loader",
                                         base_name: "seam"
  end

  test do
    output = shell_output("#{bin}/seam workspaces list 2>&1", 1)
    assert_includes output, "seam login"
    assert_match version.to_s, shell_output("#{bin}/seam --version")
    refute_path_exists libexec/"seam/node_modules/@anthropic-ai"
  end
end