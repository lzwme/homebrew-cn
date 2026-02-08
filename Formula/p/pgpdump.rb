class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://ghfast.top/https://github.com/kazu-yamamoto/pgpdump/archive/refs/tags/v0.36.tar.gz"
  sha256 "9831fb578175f97f77e269326cb06e5367161e9ddbbfb7f753cef12f0f479c1d"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b3d1b4c62b3420ba247b531634b3ba7a5ab5a03da5f0bde0552d274f1c59801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4034a5d2c65204a8ae76b66c13256fb2875e3e790f95c017c51526a5a4d09be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d92ba9dd3c52a582ad4f98568965ba0e14449985d06e4339c8735fd41927872"
    sha256 cellar: :any_skip_relocation, sonoma:        "247c8276634d3c8e941db5b8dee3face4b26d6544f1a5d82c17150aefceb65cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5066a50b615b07419755258920c5fbf8746a34849ecc1c74d56c86ffca8ba701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04042cf505e1ebaa0ae1c78a69a3fdf038a128d1fb1a37b438116b724bd6f26b"
  end

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<~EOS
      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1.2.6 (NetBSD)
      Comment: For info see https://www.gnupg.org

      owGbwMvMwCSYq3dE6sEMJU7GNYZJLGmZOanWn4xaQzIyixWAKFEhN7W4ODE9VaEk
      XyEpVaE4Mz0vNUUhqVIhwD1Aj6vDnpmVAaQeZogg060chvkFjPMr2CZNmPnwyebF
      fJP+td+b6biAYb779N1eL3gcHUyNsjliW1ekbZk6wRwA
      =+jUx
      -----END PGP MESSAGE-----
    EOS

    output = shell_output("#{bin}/pgpdump sig.pgp")
    assert_match("Key ID - 0x6D2EC41AE0982209", output)
  end
end