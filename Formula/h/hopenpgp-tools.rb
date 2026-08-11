class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.25.5/hopenpgp-tools-0.25.5.tar.gz"
  sha256 "2a0b4b0e3d97d98c2e49e799e5bedd8e4b9ca697d4d5f396f05606ec2285cf18"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2214b33d22a61e5330830a8316b8ab4bd25434f7236edc734a8d9a5411ee7c7b"
    sha256 cellar: :any, arm64_sequoia: "188101e4ba9e8b99dfebc68eef5667d948509bcddb1a973f8e37d6cdc15d4442"
    sha256 cellar: :any, arm64_sonoma:  "b78b53d214c7539ce3b0b5e9908014841efea614f92de101c43759d3443320d9"
    sha256 cellar: :any, sonoma:        "fff1061575dd7f88306101ad52911cda2f9d3a5e2f528c60699d6b304ced0b3f"
    sha256 cellar: :any, arm64_linux:   "ac272c8fb0fb03d11e13e42ffe5ed6bd9e95063d4bff8f7c1977aa53022e55d8"
    sha256 cellar: :any, x86_64_linux:  "866602e1bcc6f5b6e30990a1c5ff6243792dc75fd99a5b6de868ffe0399ad7c0"
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