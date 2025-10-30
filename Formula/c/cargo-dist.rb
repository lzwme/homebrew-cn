class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://ghfast.top/https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "de5de74a07627adadf445f9f4424acffa85b8518a01ddc4a7373f0cc17c94333"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8df98efa1a836ecf00f3edf427b95ae5276879c5637f293edef5e1cfc3c75b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeeefcbb3145349847907feb35f743ccad802b70c31f05804192d24a6937372d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "803b8d152bcf2d22815a69cefe7956654e31b1f3aee46a59e9f0e843e11017a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c3ae124ab5b82999d34c604dbe1ccf11ba67f38aa7f09bf21f3c163ef046560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517e1d0541883c763435c56730973355be1395d3a208c947cabd989b05188a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f5ce8540f6dea1907a27523af6750f0de508aa35c64c33ebdebfab7db3df9d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}/dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}/dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end