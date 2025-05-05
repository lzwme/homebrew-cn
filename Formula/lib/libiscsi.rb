class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https:github.comsahlberglibiscsi"
  url "https:github.comsahlberglibiscsiarchiverefstags1.20.1.tar.gz"
  sha256 "6bd6feef2904de1bb1869cec935b58995bc1311cad57184a2221e09ed6137eec"
  license all_of: [:public_domain, "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https:github.comsahlberglibiscsi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc5f8c6f6c92e1fd412fc04112032eb339d9014208d27819fd92cde2756883e5"
    sha256 cellar: :any,                 arm64_sonoma:  "be090725b493c5446110fbcc7c05ad6bedc92032360fe05cc5963c940e8580c1"
    sha256 cellar: :any,                 arm64_ventura: "e710e558774e2b4fcbd1c423b945f4a63f5f55daa8f14298d42f816afcef99ec"
    sha256 cellar: :any,                 sonoma:        "2636c3307f2421f528d202124664f6a32210bf9603becc186d2cc765c897e2bf"
    sha256 cellar: :any,                 ventura:       "589f2bce4a2ccd68d527b974723f26a7c22b09faaac24bf0b91b27e383e803bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44dedd29ce36ad360bee30ddd330301ecd26ea9a9fbdaee14adaf04417002040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a477c46c38281dc7810044580134c904733d949eb3d11e3c63eae2c4a298d8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit"

  # Fix to error: unknown type name 'pthread_spinlock_t'; did you mean 'pthread_rwlock_t'?, remove on next release
  # Issue ref: https:github.comsahlberglibiscsiissues442
  patch do
    url "https:github.comsahlberglibiscsicommitfa37a2136c59a16e3112a957ccdb8197ecf2a302.patch?full_index=1"
    sha256 "02f21294fcfa9535f6ba984e7c0ac14d7c6aded387db6e744c6ebf892dc69c4f"
  end

  def install
    system ".autogen.sh"
    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin"iscsi-ls", "--help"
    system bin"iscsi-test-cu", "--list"
  end
end