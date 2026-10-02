class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.44.0.tgz"
  sha256 "8ae9f56a019a7234531409afbb3282456daa13e73549e8e4774fc535a4c9de62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb7a4387fe636cfce01daa1d5bf2eae4e29caa9a3fab2ef505e3935eace109bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "038f143f4aec4f48b96cb6766254330147b20dd0be105e6b5a2a6fcd89128aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8781f8579f9e5eb2f057bb2e162ae6524bd243117d2a350d81fed43954e25b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7a914fe016e8bb21a2809094465a84d9ec74676874386e0b573320df01a8193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "591ac1e5a0b08417148af024c851193d80cd1a19a2055315ba94ec0337bc0c4e"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@anthropic-ai` packages
    # which uses proprietary license.
    (libexec/"seam").install buildpath.children
    cd libexec/"seam" do
      system "npm", "install", "--omit=optional", "--omit=dev", "--legacy-peer-deps", *std_npm_args(prefix: false)
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