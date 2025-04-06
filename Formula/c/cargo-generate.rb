class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https:github.comcargo-generatecargo-generate"
  url "https:github.comcargo-generatecargo-generatearchiverefstagsv0.23.2.tar.gz"
  sha256 "a9185d84940bcdd2546eba5513e24be9ae36e88e9dfaea7590fc6894dc316d3e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcargo-generatecargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b1b561dd0c968de85f4d775a607f2d2b82089237160920d78ee103ed6a42c6f"
    sha256 cellar: :any,                 arm64_sonoma:  "c11a004c6070b94b52040f94e5146bd34621f05313235f1a0a9bf5074ece236a"
    sha256 cellar: :any,                 arm64_ventura: "927f645b12b7bb78654c7af99f97701a16dfc7d3cbfd9028952f0935065329a7"
    sha256 cellar: :any,                 sonoma:        "71c35d39c476b10b0f3bd2d6aefcf6175f9495e851ae736a2d76e1c70bb697ea"
    sha256 cellar: :any,                 ventura:       "7739e66a01f670978501af05f23b90eff4ff9f29367ddc43d7f14c1c4b887f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6959207d72fe2e591eb80db131420c9cc5c8909d427192857603b323dc78ff69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e980cfeced7eed830c49ddceb5b398af6edd284bb09d8e641c4600d2e8d80c95"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utilslinkage"

    assert_match "No favorites defined", shell_output("#{bin}cargo-generate gen --list-favorites")

    system bin"cargo-generate", "gen", "--git", "https:github.comashleygwilliamswasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath"brewtest"
    assert_match "brewtest", (testpath"brewtestCargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end