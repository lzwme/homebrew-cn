class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.27.2.tgz"
  sha256 "ddb148bf0cb69f50821dcfcb8bda803ec743536b26c0ae7ce1593359223b27fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88622228e3abea43a2aaffb45371f7950e3f05967e15b9be8fc37fb1067d1bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357d2ebb780b8a77a273d30c5c5e5983a0b87780b272d083f64c934254c3e924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf2f8b203b6253564af715d92bd5ad4a3bd162d655d55e3962b0f3c1a5ceb412"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d5291d124e2108faa51bc80c97f8d6be977b424460ddf97f12b4cbdae8e081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78496a97c56d5d59b51aef6523e4634b4b2eca08ed6fd62cc1fb65b44dc1cfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a4f24fa304a51f72e0c8c66799f9015c7ee462dc56d323a3fbb35f4409acc0"
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