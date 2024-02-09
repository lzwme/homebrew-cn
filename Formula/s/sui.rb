class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.18.0.tar.gz"
  sha256 "6e69d7fa884ae22821666bd2d45271384c3a7378fd58de2f5b193a8ec5a303e4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf486e3775e3397491dd166b9f0682dba1b27fadd66261245c931df7d87c465f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffc439a7127b59f5907a455ce554f86f03e1a23e96303cf4c0d270619db3f3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c45c5fe7d4f677fd05b50549685805a9153c9c079f1ad3db9edc8c63ea0d97"
    sha256 cellar: :any_skip_relocation, sonoma:         "76ffef9dfd6d74470ecfcbb8389ebfac0c2af992cfd3a6f24dee3eb3ed9a1cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "9b64db5e65e03ac61efb4a93c7f5bb28a9f1d3421ac6809ae84dc809b15f8aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "0f65f5faf4576bf002c3be59216af3451ac7e781cefc12e860ed75811ea0a05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d9ae047d6de02a8277919dd11d7378a3e3c9a0ccebe5d126537e0a874f0444"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratessui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sui --version")

    (testpath"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end