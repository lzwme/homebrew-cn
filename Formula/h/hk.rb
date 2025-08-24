class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "131b35f2bb882c7bba88a46414e23a3b402c5304270672342b3165c787336cc3"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20807d8bb0b041274d1ad5926b9c68e6d288ca63c6cd8540b77dbd3eac46406c"
    sha256 cellar: :any,                 arm64_sonoma:  "24bf31906d533b4450916d00ebc607c478e5e2b056eb49aee247f77c89787ccd"
    sha256 cellar: :any,                 arm64_ventura: "7ebd3e9df76cfd42d9172097a646cd18e74ef80f4d073fc7e9103805428c4290"
    sha256 cellar: :any,                 sonoma:        "6c7cd3b738a0ea164546034a1284a034ecb3d2d00f458bb0a53d9e9c00b9566d"
    sha256 cellar: :any,                 ventura:       "b53b79b9ef8d8b4bef92b447f68db3626500be34789adf75780684e2a4eeecce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "183f6d9b3e1c5c4a9e280b7fb09ed2ad0a9a93ace278b8f3240786d5f8dc38f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb75d3fcffa85e475c28cdb6fb419624abcdaafade4db04b9274787686ffe76"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  resource "clx" do
    url "https://ghfast.top/https://github.com/jdx/clx/archive/refs/tags/v0.2.18.tar.gz"
    sha256 "071e7cfd5afe6314151cb2153b8375d0706cf89ca684012ae36befdf61a2630c"
  end

  resource "ensembler" do
    url "https://ghfast.top/https://github.com/jdx/ensembler/archive/refs/tags/v0.2.11.tar.gz"
    sha256 "967f98f6dfd19b19e0aa91808ea5b81902d3cd6da254d0fdf10ffbaa756e22bb"
  end

  resource "xx" do
    url "https://ghfast.top/https://github.com/jdx/xx/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "cccdca5c03d0155d758650e4e039996e72e93cc1892c0f93597bb70f504d79f0"
  end

  def install
    %w[clx ensembler xx].each do |res|
      (buildpath/res).install resource(res)
    end

    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end