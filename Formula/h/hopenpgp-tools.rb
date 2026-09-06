class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.25.13/hopenpgp-tools-0.25.13.tar.gz"
  sha256 "c93eb7915c929001b26965f43e79342c128850bf62937968a6e85e1115cc0f0e"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5cc73bb1d30d9654608c2d9ffd8b4a2acc29fa7502a9eb20e21105d956891db6"
    sha256 cellar: :any, arm64_sequoia: "b68247c1cde4ec1ce8b1911944e6a90bd6ee8fd77549c54fff3c8042ab56ccfe"
    sha256 cellar: :any, arm64_sonoma:  "ce9506b0f7861bc5a9ce2718dbdd45e372e0ae26a86cdce1f868868ec53e7f0f"
    sha256 cellar: :any, arm64_linux:   "a627168244e6bcd9b9bd507b0d888ff743ea587d4e5d2c7d732cfac67c931572"
    sha256 cellar: :any, x86_64_linux:  "af9c53ea59199f2029828204c2a58f881cd1617d95c88514681c487526ffd89a"
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
      type :unofficial
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