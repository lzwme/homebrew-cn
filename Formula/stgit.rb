class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/https://github.com/stacked-git/stgit/releases/download/v2.2.3/stgit-2.2.3.tar.gz"
  sha256 "4f182007e658258e2dffffe0d01582f3c7e21e524eee04fb29153cdf38b0f6af"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c65aa9fb7bad5b0bc56641c43cac65af5d1c16c94ceb5922aa0bb72fb23c1e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc2326a25ec083c35cdd1963d86b691e126894db2b4ab4702e6211122743eaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264d83c21c10068e3ef1408cd53eda6db70b1d2b27913a4b420d64a73044d624"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb6ab42f7b11866598a1bf0a3829f7c82763b9e64c242d7a8f5ae318a5688f2"
    sha256 cellar: :any_skip_relocation, monterey:       "875e772f351f0020fa915b54a9b5008332b89b69e723b7afe360a24311e76165"
    sha256 cellar: :any_skip_relocation, big_sur:        "43247b80c16d4b493728a8f949e37f24535c34a70f8b05ddcfd188522958232f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e6554884a5f8c21bb49444f04bd95a8b341c73d495be23fff995c20b9fe1a9d"
  end

  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"stg", "completion")

    system "make", "-C", "contrib", "prefix=#{prefix}", "all"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end