class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https:opensource.axo.devcargo-dist"
  url "https:github.comaxodotdevcargo-distarchiverefstagsv0.27.1.tar.gz"
  sha256 "c9791b7475cab956cd876905fac32a9e9760cd1e69ebd4bccd25d98e013ff825"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comaxodotdevcargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8b03cf44d6ff15c2d1f31d9941c3e5c324da33bdad38ec54e4052ea06697a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212a9ba8dd93e4bea961f06663522d39c8df9a1a04a4118678666cac92356445"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dd2f988d7cce1f18402f9ca650bbf4a6889df63e39006afb31ed12ffa9e5487"
    sha256 cellar: :any_skip_relocation, sonoma:        "51cbcae1d7ae78287ec3989dd9a932f797f0a6a3cab411a59dff6617b4d8b273"
    sha256 cellar: :any_skip_relocation, ventura:       "955edf21a2e8f12f3817f07dc9e0f7a473b05f9e9b05a70cc3141890cce81ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4181b60cd88138b60e17355aaa92aa7abdcd17289ea3263c7427661287747aba"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end