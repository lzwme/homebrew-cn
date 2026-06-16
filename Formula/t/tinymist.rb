class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.20.tar.gz"
  sha256 "8b5aec9598102b0130a7b27ef8cc5e213670f528474183a42bed0d4549b86c5e"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffbb704d799070e6180bd410798eaccf19338bc7c258aea67bc7044ea5c416ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64dded3490b979ac371256f3f92ae5edf7da2d58ea080eaacd76ed3e14f0d042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c909fe8e9ee7e0f8ea8af8a3d8b2936b3ebeb9f9473d7ff760901b6797d1a8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c09af47608a622626393a548293ce7acbd36d34a67b006d933a28169ec6861"
    sha256 cellar: :any,                 arm64_linux:   "43d1fd850d494b511fee10f8535afbe3fbf4b34addeb7abc173d84ceef2f6786"
    sha256 cellar: :any,                 x86_64_linux:  "6087a087a6db6103af4e533ff88b18e79818f025b49f808a7c4774b075566187"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
    generate_completions_from_executable(bin/"tinymist", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"tinymist", "probe"

    (testpath/"test.typ").write("= Hello from tinymist\n")
    system bin/"tinymist", "compile", "test.typ", "test.pdf"

    assert_path_exists testpath/"test.pdf"
    assert_equal "%PDF-", (testpath/"test.pdf").binread(5)
  end
end