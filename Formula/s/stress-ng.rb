class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.18.03.tar.gz"
  sha256 "a19a25ba47c9196db23aab97df4ef55d8ec80d8a5a6afe580b3bec2b870422a9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053f848443172b59c40dabf02b12dbb150815e1924a2668b148e1560bfbddc1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d10fee0460ef493b7b44aa8042b4b35202225e53f2e38932a601a13e47d4b460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6026f2cac37cb4c7b21c465db2333fbac009767359bf4f21ff207a58d73ea6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7454ce27c3d5b1268774ab25c5b42660fc9cd935ee83c8a30d2005a6135f78f"
    sha256 cellar: :any_skip_relocation, ventura:        "f0a2f7d84ae6138a891264e728c9a712f89173b4ff9296c2393a1ed405ba7d7a"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee4a1c7d393abc4a6ba48a57ec7f9fb9e12081fababd86d7717317e2173aa0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e52f4cab697dd4865a041aa6e2b8f64289478f28994857a15ef855b081d1494"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "usr", prefix
      s.change_make_var! "BASHDIR", prefix"etcbash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completionstress-ng"
  end

  test do
    output = shell_output("#{bin}stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end