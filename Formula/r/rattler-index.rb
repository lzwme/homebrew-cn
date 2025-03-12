class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.22.0.tar.gz"
  sha256 "7782a312f42c5edeee83ceb9ea2ebc487bb6da638e8ebf44a6c17669876d5549"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a784be411f8878e306c1a6f9c5da87b454745cf4a1ffd3dd8076f8f20f65bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bfc8a49a9f86ff720a074315b296dd6e4019a0963ac8f6731ce9ad2f2ffec38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "878de69056281771df632a512e41e5f7e2c776d4b914a4f490c4305f7e6d1baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aa63cc6e5574546c8ca9ecf22b5f0879504e48cb93d37830f1889a0ff450680"
    sha256 cellar: :any_skip_relocation, ventura:       "62c1a0fbc23e7d7bf740d3771e30cacea5e5200e5d6faa90344c66c149b6a045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2474f6f99d982d07cc76e0786e72f4df22b18bcbbdf8ec5cf4cc18e72a2f4092"
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