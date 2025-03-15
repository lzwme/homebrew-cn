class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.22.1.tar.gz"
  sha256 "23b5767f158a6827ea18972fc2fb3729f6aca6b25f1508d05ab8fff9ad839f6e"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5acf2fc0159e338d828c8dcdb7f0d19949866acbf07cdc198b86746f23a401ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7554c158b2fbb5cbf620973183971a3b11449f36b021d9a0a880d37ad6410e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1db951a806fbbcd2a4a1639cda3d27e46b6fca5dba781772ba513ab316964cfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "261f53a92cfd56a6a7aad0d2b768497293565db761c12a8e70b27311633b6862"
    sha256 cellar: :any_skip_relocation, ventura:       "78fe7143aacfc0b1a8ad4ab6c62b4505464c1d68fbf8d3b41622bfee7a154c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d840ecbe42669287cdfffd35c2ae1510ba5e735b372a052709ca883e9a8807d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end