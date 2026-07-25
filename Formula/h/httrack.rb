class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.14/httrack-3.49.14.tar.gz"
  sha256 "7ae885878f1b3d6c6754a607e8abccf7fcef915ef153906ddea7fd2070ccf368"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "7446dfbb80a066b981a174be9e22387792a3a3763ce89239efc83995a061e67a"
    sha256 arm64_sequoia: "d9ccb3da8730e16652be2e3ca2ef0d607d665443e6d5772cb0e30c7a1d69f516"
    sha256 arm64_sonoma:  "ec8234285b605de181260906df38ed17ddaf2ff0f5a80bae6bec81dfb8e8531e"
    sha256 sonoma:        "cd35aa66509e34d963e6eaad18d25e58e1c94f8e5bf839223442d6a2c773ac6b"
    sha256 arm64_linux:   "d49dd13b9cf5b61ca3e90d4e9b75df18a6d9aaf1f70b35b79eaac0cc8dea592e"
    sha256 x86_64_linux:  "8b0c951efd72f5f614f765f8436f1ed4c655b391284270d0c01d6e06bdf2a4bd"
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