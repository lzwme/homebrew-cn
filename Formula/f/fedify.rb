class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.8.tar.gz"
  sha256 "89f76f2e9f4795b654ddb8fb89764634da1e63a8010704c7ab838479ff6f8ef9"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6ab6c35d9418ac5bc5b209adacb08ea866254a32b65a499aade4ed513dd9ada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72e6c21613275fce2d0e4b2eec3feda4c8e058f9e90156a18d8565d1e5f9d071"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388e239285190122d392cd4f7ab0de033e4acf0a8e1ce49e06658ffcf3c33640"
    sha256 cellar: :any_skip_relocation, sonoma:        "f956f1987b953bb659792ad352f7431ae1d2ec003e2977ae33b449ba41c31c61"
    sha256 cellar: :any_skip_relocation, ventura:       "6b8cb704cfdbdeddee13b3dcf54b0d14ccc1ee915472733da9a1ccbe8221ebe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259d377d9936e801a0fe7b5bf3933eb67ef06706a2563dd3af0a358cbbb221a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de976eba1fa6515864fb744b66ea89c3a4063f376dcae88fcadc053db235f97f"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end