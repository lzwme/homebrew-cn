class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.24.1.tar.gz"
  sha256 "3be1c18abc5a8161ecf9fd864e0d565208745b5c863a7f6005a5bbc5ed764337"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0734f37cd6f9ab32371bcd8b18b6a47a7a2cb293a434b04bb610284c94f88724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0f562cb22d22852f69c12a5284000a07773ae42d566b80abd97e66e0a2c5502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa7ee56e0cb4df88f31fb69bafa95e5b603e7ef0b0f307c8c91c9868b0486aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc682837bbf692eb90b71d5050d3ec6bd623caaaba035e5e5f14103aedcf42ec"
    sha256 cellar: :any_skip_relocation, ventura:       "1cf1e56af42a1f14dcdbee75a1ac69121aabb2d8fcc9ee3f42709045bcf85342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f74826a68dc999336f2b852a1e8cbc296060815c068ade1071006f0bb8b60da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44dba8cf381b94044ecd1d38b0b268098552f3334a5bcc43aa70ebd9d81694c0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end