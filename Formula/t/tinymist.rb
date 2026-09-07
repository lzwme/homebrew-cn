class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "03d49413dd70d06d670d3c1970b4a416201ca6076bc4a321d4ffbce9893096ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1c42a7f77d82573e39a36399221a875b9821f13a9f106012295ae77fe2beec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbd8ec6a2b1320eb3be754b70341bb7d0a92bbef39bb65af315fcdccc89ae93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a2125358abad8256c0f8bb51e149f3b2bdb66a2be83c63d572cab0517ab235b"
    sha256 cellar: :any,                 arm64_linux:   "b4fc16e34ab396f5b23a9faed713434039f9d6a204bd019c6aa05c90f1eb2682"
    sha256 cellar: :any,                 x86_64_linux:  "46ada127fda3c9398d4a71bff824048e51f3f0a689acbc511567f2ca69926185"
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