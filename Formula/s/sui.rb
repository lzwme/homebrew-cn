class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.43.1.tar.gz"
  sha256 "91d257e9d9a46ce428d9316852a3b59f64f3fcb2ed100cdd592aa5f73e5f3510"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9eebdb2a41a2059b0d9dc868cc592d4780629e7124ac949039fc3d3247ecd2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "953cbdd4f4517a4fd9f8d43daed68146595b41f6f93b530092f38d483a648632"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9462e698418f70a0d74addad44d0e18ee207ef54a7dc66862ec6fb94b3519aa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ef3ac2cd36ee317002420fb85ce4b9bc6a60eef4dae6f0f02afda3f61918b3"
    sha256 cellar: :any_skip_relocation, ventura:       "9d5f8130b8d733b09d79c39608960d0a6dce9c81f3c0a32ad7b007a6fbc79e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed3a014912fc0ad1fac5ef6869d34fd4bddcefba26a6855610315b64a0b6980"
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