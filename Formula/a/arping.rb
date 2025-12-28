class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://ghfast.top/https://github.com/ThomasHabets/arping/archive/refs/tags/arping-2.27.tar.gz"
  sha256 "b54a1c628c1cd5222a787c739e544b0a456684aa1d4b04757ce2340cdd4eb506"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3aff9845c1fd707997efed9953bb134dbda55a9c72c80a7d06fe7ae23fede6e"
    sha256 cellar: :any,                 arm64_sequoia: "25d4e9b1e36a6944be8a1c4d40b90e42b4b9e879eedea9de5d767220e2f8c138"
    sha256 cellar: :any,                 arm64_sonoma:  "c6e844d75f708b7ccf79291715943316e470125adeea1d2f20476e5a6c5b7e63"
    sha256 cellar: :any,                 sonoma:        "60b619b4e702d9a83345324dcf66d6ac9b914e79a10f4998160d73ba38adf967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0802cd9860cbedfe5dd7c739813eceb9cf2e983908e8b56163a34df90641d1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "520897903811e7126ae3c4ade9c554f8b134a36a5c91b76d45d47c0d073cd63f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  # Fix build portability.
  # Upstream PR ref: https://github.com/ThomasHabets/arping/pull/58
  patch do
    url "https://github.com/ThomasHabets/arping/commit/9c6758ad17b0b11ab5abacbed511379ff62255ca.patch?full_index=1"
    sha256 "b618a1e6cd517b40d42a2561d6b0c6dbfc90e89d5d5d6032e9b899d3caf17e92"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end