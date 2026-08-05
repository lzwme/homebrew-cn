class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.25.3/hopenpgp-tools-0.25.3.tar.gz"
  sha256 "193fa587edfffec3db0cabebfde0fad9b216e53392d3bd5d3e986d47e980ee6f"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61a90694c1156b65243a2b01d6f503ef754e533181da3fea407b978a47913751"
    sha256 cellar: :any, arm64_sequoia: "e4dca0a9923b8e492f11722ae1259b96e967e75a7236c9776cdb8c2dd98aaaca"
    sha256 cellar: :any, arm64_sonoma:  "f06dd3b3ede85e195a5a5042731a11633d397da87e465dc075858421305708be"
    sha256 cellar: :any, sonoma:        "c68556500839b0e182e5f66261ab5a9fc558293092439de2e28b44cce40f4a34"
    sha256 cellar: :any, arm64_linux:   "4a94f3bbeed3a2542936f74ba46c21b7c2e35f12eaa3c8f926625598f946668c"
    sha256 cellar: :any, x86_64_linux:  "e4210102d511f902cff4ac48b64405b3ec35b1a965bd3ccb5459c21ea099a35d"
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