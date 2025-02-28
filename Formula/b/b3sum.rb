class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.6.1.tar.gz"
  sha256 "1f2fbd93790694f1ad66eef26e23c42260a1916927184d78d8395ff1a512d285"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65d64c62ab2484cbdffbece175eff2581aceae032870c6224b52112ec4b46afb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f153cf056349e2e9df3b243177bc640aa1591523be053f8a8940d7e3b89a3df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b70f96fe5586cb1c82c9e1e10b35727ca74f192fd7ae7c3369c1c594e534c0da"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f98173bb23fe09e764977b26e0cbba9dd256acc89fc3967bf66b795d0e31e89"
    sha256 cellar: :any_skip_relocation, ventura:       "f81531d6018c69c97dfe0798d43eff7e3efec4b6fe788f72ac8472cd9a36f1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb06f7253fc69fc5d6e84ac9089176f1463d96806c03bdc028aaa6217b33257b"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end