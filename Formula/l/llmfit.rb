class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "7d1de0440573e422db115fdf9b1e9ea981bdb8562d6f915f13bbcb133f69d30c"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc5256e4108e6d0d1d9d17a1d0b1f9fe90bdc4075bc4abf6764f8724a456ddcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f7c7288b2fbfb2d76c5bfe2e16266998c6624bd8b83bb9436f1748c6a088fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e195da04bcdb7c2633e02675c624b64b3036b5d22a05cda7436ff94fc07f14f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f39805cb5ba39f96af10a24d4b7a7bfe4153c81b23c87ef27d48413468a333e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41fe45e23b0e360b87e1aa3f95d3403b03afb898ae2bfd45a5460cb5b7b21e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a6460affa14adbbae0e0543c96716031e4a0e5b872308ec6062fc8b47d95e48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end