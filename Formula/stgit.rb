class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/https://github.com/stacked-git/stgit/releases/download/v2.2.1/stgit-2.2.1.tar.gz"
  sha256 "e8cd7da119a3bf3c36d3254f44f753eaf730882e37607b519ee0fadebcf48a73"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee23577efa0e7e30c41176c55829a3037a0662d65383958efd22eccc83a0990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d47141f332801e6b602252ce90ae8703fa1d2487bb0a242c3a4d727c996598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "797bc5ff0467fbf82bfc0f7d84b8dd0137579c832196e69c15f5fc0d33300f32"
    sha256 cellar: :any_skip_relocation, ventura:        "069287ce66e50c6c0cbf0f278447b1e21226b895cc7e87620e996fff20e8c17b"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1b321ec089e6919785027143f6d05c37ab9ab5c58fc036d8f48987385eba71"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fbefc688c67d24a8afd6310dfef2b32524530d711b81b6e1847002d9de9ea54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b98540a380de21696494d94eebbf598996a5fc2f92d966d1c92ced9b830d5ce"
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