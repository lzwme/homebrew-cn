class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.39.3.tar.gz"
  sha256 "21e6db1df48021f48a48c4e81e2fea9c17fbb00a8205658524cfe98d13155d88"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "794422a4dc2bd03e5d0ebaf1994d48eb8d74da8d8aacfe415bf612bfb77b36b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b2bc88f36df875a6cb23112c8932252ed29269cccd59ccb9e2fb8a6c24bc80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e31d63090fec90a62a46f5f8168916681be913c6cf2aaa6118f05fe009a805c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba625a50b5e6e6d80f17a700c327c2680f57cf11d8110a5bef0dbf6491ec3eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "f4cd44c0a610d2293b9e39b61164253da7a602f2536da06436dcf22adb038718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe68f8c8736902c8200a9cb200aab365c5fa8f76f54f483cb69b52e5d451247"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "cratessui")
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