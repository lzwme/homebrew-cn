class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.2.0/libgit2-glib-v1.2.0.tar.bz2"
  sha256 "421ac5c99e02c5b6235842e60eb7f9fa8dc580d2500fb1eb521ced8a22de9f29"
  license "LGPL-2.1-only"
  revision 3
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "18954f6aaf601c8f845989582a3d11668bbe01f40ea79bcff227e968906fd177"
    sha256 cellar: :any, arm64_sonoma:  "a001955812e61357788cbd1850a43c9b26c1240b4662670b5729747dce272cd4"
    sha256 cellar: :any, arm64_ventura: "dcdbedb74758f2f5a2b41f88f3a41e66a77c816c52ed19acfc967d57af9cac2a"
    sha256 cellar: :any, sonoma:        "aed90c346cfc1dc55c380a41229700c4522a095be49777aa1aa090105f107ec3"
    sha256 cellar: :any, ventura:       "fc4bde42fda94779073a8ba99b1b02c7f08446a08d5f89a4948f67af3427b209"
    sha256               x86_64_linux:  "b2010f146b29c53b313bb13c00baf3d2071b5fd95f1a6d68e5bcfa97fd7ba291"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgit2@1.8"

  on_macos do
    depends_on "gettext"
  end

  # Support libgit2 1.8+.
  # https://gitlab.gnome.org/GNOME/libgit2-glib/-/merge_requests/40
  patch do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/a76fdf96c3af9ce9d21a3985c4be8a1aa6eea661.diff"
    sha256 "24d32bfc972959c054794917f4043226fc267fafaaf8d8fc7d4128cfa9b5b231"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", "setup", "build", "-Dpython=false", "-Dvapi=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    libexec.install (buildpath/"build/examples").children
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end