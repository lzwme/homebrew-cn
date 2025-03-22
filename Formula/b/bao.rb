class Bao < Formula
  desc "Implementation of BLAKE3 verified streaming"
  homepage "https:github.comoconnor663bao"
  url "https:github.comoconnor663baoarchiverefstags0.13.0.tar.gz"
  sha256 "05a8bb641710eb70ba59f2a765128211a554b186f117a48bb0c10e055dc23db4"
  license any_of: ["Apache-2.0", "CC0-1.0"]
  head "https:github.comoconnor663bao.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a34e59e198022fb43942d134e711ae5e3676f51867c3e15e1bc63685306815c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f63529b46e6ff3963b1184f5b72138167bbf73fed196af8f6db95d94a05ab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55fcf74c342f34f5f18696f788335b2c0d14a575a892c38b89762e1ac3222bcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c858c8d4530769611f9e1af9ebbba5a435033887371943ae564f12f84353eb74"
    sha256 cellar: :any_skip_relocation, ventura:       "ac13765ab2cd2f636be2a21e8e5b258ad18357900a58fa5d1da9f8b8dcc19f45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11ce6005470b8119b70841eb7201e30ccd1f37f76f78676e986702303ece1186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aef308095d30ea08a9bc174fc4620c032d85aaf4d2037cc0ea8fc37db96795a"
  end

  depends_on "rust" => :build

  conflicts_with "openbao", because: "both install `bao` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "bao_bin")
  end

  test do
    test_file = testpath"test"
    test_file.write "foo"
    output = shell_output("#{bin}bao hash #{test_file}")
    assert_match "04e0bb39f30b1a3feb89f536c93be15055482df748674b00d26e5a75777702e9", output

    assert_match version.to_s, shell_output("#{bin}bao --version")
  end
end