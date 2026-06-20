class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "808181270cd870f3088dd967d78c511ef4c8840508b4822f1d44471cd27afa94"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3fd096f55838e4f5c0d23a561bbb3ebac7ddb8a1a80fce15b33599ad7a9e9c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460bfa2ff669db236c5ab195fa8a95af7c8a6d970d42909eaf19d2f7f7e7a6b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d26098b3da0bb8f7e6eaf420d88a23bfb41c4357d10dd05cf7b3b8f8c294f09"
    sha256 cellar: :any_skip_relocation, sonoma:        "99583be474e15e20b87076f4c3a447cda55ffe5f019d8f6c07dcb4b727613659"
    sha256 cellar: :any,                 arm64_linux:   "1c5fe1d95da3edcffd7f380af645c79a6c9d70d1c1aeb9f86bede9e555d76dc8"
    sha256 cellar: :any,                 x86_64_linux:  "d113c666ab41a90fc62a63672ba98d83bc1721a540c7e838a1f4141776f941fb"
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