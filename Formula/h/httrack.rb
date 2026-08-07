class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.18/httrack-3.49.18.tar.gz"
  sha256 "a1324a74fbca6e86ca826cef631125192a5743351a71c39f74e1ab18d3ee8538"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "842e2f82c37586215a0ea25fc8ea445541ece3e87f9750641f59c2ca3223d633"
    sha256 arm64_sequoia: "3abd927643e1635c4370af4be1f3e11841c09dd15cc6b75720b488c76fe64667"
    sha256 arm64_sonoma:  "3cd95dd604376d2907bcb150e859e21484970c813a10af34d225e0c9b930e46b"
    sha256 sonoma:        "04e99531b4d1ecd22b3eb285fb2ee552d3efc84a305f50c22000c83a517e27c6"
    sha256 arm64_linux:   "23a1d666139fd7b40a446749fbfe51a44946a27ecbb54640a499d719d712db64"
    sha256 x86_64_linux:  "16558de22b12eac57003c331a15d6ae5682d72b341f59aacac3132e3124aecbf"
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