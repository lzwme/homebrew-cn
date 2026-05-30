class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.23.2.tar.gz"
  sha256 "4d0dfdb445ae90c75f064429ee88174f0f8370ba9183e0dee5dcc8957a23cad9"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee2c042ba7bd855022edd6bf369671edbff5689c4caef4cf44573077376c2878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1d3bed4e7fa2280468f589a5280c894b6624bf077b08a2e0b6b9e9e814fbe3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc6d259ff4cf1e24f9cef6e2ec91d0f32b5870022a344b037ba294ac17b6c6e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e847398532b2532ab5a9c8822eaf589680dc9fa7d5fc717a1ff15b6872772958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8455a8c1d005f4fe41f9baf7d284f16475d5b34be344cabc3c8dead4cc588df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09596927c9b03ef04bdd67d9429395ae20a000884d8fe769571c0139afd7dc47"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end