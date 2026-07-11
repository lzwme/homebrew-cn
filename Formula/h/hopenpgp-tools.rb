class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  # TODO: Check if `ixset-typed` resource can be dropped
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.11.1/hopenpgp-tools-0.23.11.1.tar.gz"
  sha256 "d79adea3ce0d399409d40571e149a17f895e88d79cb50c37cfed94f903815031"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "18ca974372b32efc2b4381d470abb87c6d391b6aa7f3cff730ef7e0b592d4773"
    sha256 cellar: :any, arm64_sequoia: "937aa0acac9c3672e4f35622ebcff0d8738f4711524277fc90e40c7b0c28bad0"
    sha256 cellar: :any, arm64_sonoma:  "fb595225b13f060f2fb1f44f3090c262888550041d05aa1173f4e916a5fda759"
    sha256 cellar: :any, sonoma:        "f4726d93f386584e0d00ffb4e900bc1682b99cab3e91fa3904093125c0af6a8b"
    sha256 cellar: :any, arm64_linux:   "27f0dbc78003faea981ab5dce9703928963754045e2cd8e6a354ee1601d51d38"
    sha256 cellar: :any, x86_64_linux:  "2a140b53689d491fb528b8f0907cce975e9f88c761215d8706c730ea00efbb1d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gnupg" => :test
  depends_on "gmp"
  depends_on "nettle"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # TODO: Remove resource once new release ixset-typed release is available
  resource "ixset-typed" do
    url "https://hackage.haskell.org/package/ixset-typed-0.5.1.0/ixset-typed-0.5.1.0.tar.gz"
    sha256 "08b7b4870d737b524a8575529ee1901b0d8e39ff72298a6b231f8719b5a8790c"

    # Backport https://github.com/well-typed/ixset-typed/pull/23
    patch do
      url "https://github.com/well-typed/ixset-typed/commit/460901368dcb452d352a17bcd4b8f60200a6fa71.patch?full_index=1"
      sha256 "e284534df9ff14f49dad95a6745137c36c7a6335e896201c577d709794882e4c"
    end
    # Backport https://github.com/well-typed/ixset-typed/commit/1ee029539a77b0c7d854660707c9daa957d6fb11
    patch :DATA
  end

  # TODO: remove resource after once haskell-nettle supports Nettle 4
  # https://github.com/stbuehler/haskell-nettle/issues/12
  resource "nettle" do
    url "https://hackage.haskell.org/package/nettle-0.3.1.1/nettle-0.3.1.1.tar.gz"
    sha256 "d548552c257ad0c64ddec7d4605456b0d0a672ca95eb6a3f761e19c6815acb42"

    # Apply Arch Linux patch until upstream supports Nettle 4
    patch do
      url "https://gitlab.archlinux.org/archlinux/packaging/packages/haskell-nettle/-/raw/aeed8e35267fb46cb17b137ecb12d2d34caefdb2/nettle-4.patch"
      sha256 "7de52534a84bff5f6893ac9267d268990ab2532d73016fa8dc31ef9169cc2c08"
    end
  end

  def install
    # Workaround to use newer GHC
    (buildpath/"cabal.project.local").write "packages: . vendor/*/*.cabal"
    (buildpath/"vendor/ixset-typed").install resource("ixset-typed")
    (buildpath/"vendor/nettle").install resource("nettle")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell", "--constraint=aeson>=2.2", "--constraint=errors>=2"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

    gpg = formula_opt_bin("gnupg")/"gpg"
    begin
      system gpg, "--batch", "--gen-key", "batch.gpg"
      output = pipe_output("#{bin}/hokey lint", shell_output("#{gpg} --export Testing"), 0)
      assert_match "Testing <testing@foo.bar>", output
    ensure
      system "#{gpg}conf", "--kill", "gpg-agent"
    end
  end
end

__END__
diff --git a/ixset-typed.cabal b/ixset-typed.cabal
index 888d8a7..e42b86b 100644
--- a/ixset-typed.cabal
+++ b/ixset-typed.cabal
@@ -38,7 +38,7 @@ library
                      deepseq          >= 1.3 && < 2,
                      safecopy         >= 0.8 && < 0.11,
                      syb              >= 0.4 && < 1,
-                     template-haskell >= 2.8 && < 2.23
+                     template-haskell >= 2.8 && < 2.24
 
   hs-source-dirs:    src
   exposed-modules: