class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.2.0/libgit2-glib-v1.2.0.tar.bz2"
  sha256 "421ac5c99e02c5b6235842e60eb7f9fa8dc580d2500fb1eb521ced8a22de9f29"
  license "LGPL-2.1-only"
  revision 2
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "228ecba137404c9986086b1e844e03828d8609e731ab63fc7d8d1d2cb933d182"
    sha256 cellar: :any, arm64_sonoma:  "31426f6acef6e6bc0d07f9b9f355d5dc7e8a0e5289e9f84a5e4bc9b09da8e18f"
    sha256 cellar: :any, arm64_ventura: "1602ed0567bf6203c09ca34b3889e9f0a03e668e0bf33b41fc381385ddc3cb2e"
    sha256 cellar: :any, sonoma:        "dcd4eb64f5de25860988f29718ce3448ecccca65b6f1b7567538243e84d23cdd"
    sha256 cellar: :any, ventura:       "c61c5352def3fb6b04f71112f2c0ff27da10735763833279a6b5d59641d1eca4"
    sha256               x86_64_linux:  "598a0961eed94c0ee532053b65bff724393737c80f34af4fb77a744d03ee4ff2"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgit2"

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