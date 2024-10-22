class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.36.0.tar.gz"
  sha256 "e43b17b7ce2c5572ee7376f828d7e064b4a877a3d24aa8b3e8e3d6e3849d0900"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb40e660b80488a21b704f0dbbaf8a8b635e88532d2dddf985b3bd98edbb15ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca7626a334c5b7a8d97a688b7a064049799e24f1962723e0f0834b0151bdda0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c80035548383466a30684f345c658f9ab2fc3f3641b380c7c0ace9a6f4491967"
    sha256 cellar: :any_skip_relocation, sonoma:        "f888d7abb306865ab34a2252b44bac082b40adea08b4614368739ffd5edc763b"
    sha256 cellar: :any_skip_relocation, ventura:       "954032c29c023648b8237d6c0558e4931834323451ab1d94ef7ada3b23ec1a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3016546a0be48b946370ba485e0aef4835441bb7fdfd67cc8276802eaa51a3c4"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
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