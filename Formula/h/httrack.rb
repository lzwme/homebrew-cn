class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.21/httrack-3.49.21.tar.gz"
  sha256 "620528236cc1f62076a142e57ada47763db121bbff73baafb14b914ab89dc35b"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "55f18125ec2c99fb5ea2ac8d0783c39933e4e9bdd4f60e448e4ce092fb78f8d6"
    sha256 arm64_sequoia: "e0ff581efe37b1a260185453a1be6026b866abd2a748273791996a4702a9ce8a"
    sha256 arm64_sonoma:  "3a68e1513d397d1ccd0de96449a573f3d70416a1a1bf761393fedfa28fd0df01"
    sha256 sonoma:        "d999787ae5f9bea895f23d8bcf3f091d9a2e492e5b20bb8fef8e8b05a17bc910"
    sha256 arm64_linux:   "20d26003e2d9f4f0212173bc61ee171da35de133075d16280524c9963d64b14b"
    sha256 x86_64_linux:  "403085954d4b45e925a9a64d8989b6c5849a21fced7512596e60d13435b3b372"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_r(Dir["#{share}/{applications,pixmaps}"])
  end

  test do
    download = "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end