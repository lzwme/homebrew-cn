class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https:github.comCyan4973xxHash"
  url "https:github.comCyan4973xxHasharchiverefstagsv0.8.2.tar.gz"
  sha256 "baee0c6afd4f03165de7a4e67988d16f0f2b257b51d0e3cb91909302a26a79c4"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b9b57e7f37df3a4ba3793b60cd61a44c148aa3ee69d138dff6cde7291641c5ae"
    sha256 cellar: :any,                 arm64_ventura:  "841a9ac70d19c9a9fcacc6b7fc7ed2ad224e0c8eab84cb0d9dbcc091e9349ca6"
    sha256 cellar: :any,                 arm64_monterey: "6bfae76adb7d87bb7249a99333402a38095bbf79053ba0f5b151566bd606cf57"
    sha256 cellar: :any,                 sonoma:         "fea1f3584f908522bed40578274894f86b1f71f0d6f183fb135e09ae2fa13e47"
    sha256 cellar: :any,                 ventura:        "e5ba395bbb5e69b4ede8657791fe5b55cf06805acae135a4377f168cab761369"
    sha256 cellar: :any,                 monterey:       "8fc5b6f53bf1e22d0bf44ff06db9193997a9272eef1d1479b1c824f0c74e0484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135bab6743d603d51b837eb025ff4711243e2f5c6086aff63de4d536c2894305"
  end

  def install
    ENV.O3
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    prefix.install "cliCOPYING"
  end

  test do
    (testpath"leaflet.txt").write "No computer should be without one!"
    assert_match(^67bc7cc242ebc50a, shell_output("#{bin}xxhsum leaflet.txt"))
  end
end