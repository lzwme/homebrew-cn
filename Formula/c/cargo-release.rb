class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghfast.top/https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ee2f40875c2f9abc647c9c074cc88a06a093ffde98d95154de38db656551c393"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c77baae485291ed6b422eb914108a74e94ca8c967eea0c7a2a54ad7b521d0826"
    sha256 cellar: :any,                 arm64_sequoia: "2fa219505d89d8cdd0232e13326f6dc2926f2a1304cc590f4a3d9183d59c9929"
    sha256 cellar: :any,                 arm64_sonoma:  "29e92454046463a08885e10d3bb9a6656b7b5ab847b229210b959ac0c3483a02"
    sha256 cellar: :any,                 sonoma:        "99fee4971fed8bf6fe7d1abb358d634861c902bc6a2eefdeedf73324370e7854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65bd9ede6339d92e2e2d125cf8649e13043b7d06ac9d1524e5aeb3978c8010fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a81710c07eb5fc14bf9bd94defe8e0afd59d54b69cf9059938363168d01ecc7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end