class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://ghfast.top/https://github.com/devmatteini/dra/archive/refs/tags/0.10.0.tar.gz"
  sha256 "f790665e760576aac5490c2cb39f78b2547d49975b0cb39a3a4f5376c1a1305f"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7020f34c23a2270ac2be8f5abc46ab8194ff0251f7659d8b3b32a49ca4cb454e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3167e3fa8280e22d3646b5fc92a7deefd19da1a301accaa6b17e3047f5debee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b41726e471051a0e9817bd12ef8b4445ebb46907ad2fa4480c112eb8373d659"
    sha256 cellar: :any_skip_relocation, sonoma:        "e811c9d6a7629c16e6353cb0565247e6546c908e4765b7158f035b57f1e9f83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c314cd1e890e65851075fb8d44b73cc7e141a5e158f7d664facc243fe95f8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7e970eee5cbe65bf4315205b98f81a2d5872714e19d0707465ad2a36c5ed8d7"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end