class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https:opensource.axo.devcargo-dist"
  url "https:github.comaxodotdevcargo-distarchiverefstagsv0.27.0.tar.gz"
  sha256 "d673c270c9da1e57a294c45ff18a1adee1b7739e05450e0062a243de8283d041"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comaxodotdevcargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c2e6416e92c1cfdcb1f730fd323e60e41e94456a0e2c400a44fc01bf6c13bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7773c14c3a6af2e56413f5dab8b2ac97457169ec35daf90cc8599bc6318dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0183e2adfee6d2677a331e885d1c0c9b7e1bb189ed718bd218fcae5127ad664"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd21a44e0226327993c43cf09ba3e58181a0dd55db60b2289fc47643c1edf5e"
    sha256 cellar: :any_skip_relocation, ventura:       "d2e5dbed32a18337964e9afbda507c7aebf99b43a369c0f5ce0da77c2509bdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221f019eb73ea38d5d5b5f4860e3f5d729dc89fd4f0068d48ceb00f4850684c5"
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