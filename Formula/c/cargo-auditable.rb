class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https:github.comrust-secure-codecargo-auditable"
  url "https:github.comrust-secure-codecargo-auditablearchiverefstagsv0.6.3.tar.gz"
  sha256 "b89c69abc1b0887345d182e5031db42dfd2e0f889de59d91390a5bb77fcb505d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrust-secure-codecargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04667d907159dae3845cd976c902886a5f17c9b90e6227f71ea20954483cc905"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c55dadafd8520b6e9e91c0a81ae705e515aa014f751c4ddad67760ee7ac59f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e69f414245331e35f31d1295457c59bd598e8369b6920059d3cae1638d38ace7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6e29293dae32f8cc928a3676bd8c404efbe82333d1bd26bee6a79af68b21088"
    sha256 cellar: :any_skip_relocation, ventura:        "027e7b3f701f6528521d00c5f21f61474cfc13ab6a0562b4d16d220189075ddb"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a1278c4986e9beedf9c38ae355abbc25f8d4efb602e71c606545284f3cfd7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b944dd861f0d9e1e4834c82fa1c7b9102b68761140471efb775e78b2ee92fe"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditablecargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~EOS
        fn main() {
          println!("Hello BrewTestBot!");
        }
      EOS
      (crate"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      system "cargo", "auditable", "build", "--release"
      assert_predicate crate"targetreleasedemo-crate", :exist?
      output = shell_output(".targetreleasedemo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end