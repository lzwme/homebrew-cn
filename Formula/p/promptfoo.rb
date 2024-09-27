class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.90.1.tgz"
  sha256 "497230eb8056e69b5d6e811f601129e614753b727aaaee55ad8addbf903190d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3589c1f1f2537f26fb32b4f9ef186e1767fc1e15c69f29d7264899e8f550dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b76e586b8bc440d8129cbbeb0d2633621343cb35287a2a7298943954b877c7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2ca42f32d3d6b19bb1415ebec79f56fc1f5839f2515394fd85faeac107175cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1612b7c3d0fa3b733a24de2eaf210a04077afa968df9039d30c274847d850d2d"
    sha256 cellar: :any_skip_relocation, ventura:       "c367bf0901aa57b6c99f680c7a3ea1edb2876d5ff62f94f269031d96e6026290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25520ffbb988617cd4d6d1b87df32466b5de85fbc276a1a377c235dbb8d58bdf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end