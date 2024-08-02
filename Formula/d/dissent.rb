class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https:github.comdiamondburneddissent"
  url "https:github.comdiamondburneddissentarchiverefstagsv0.0.26.tar.gz"
  sha256 "e48d16d16b5829d2d94a0bec777ec0087e9a8fd3ac39355feae8965e22f62eae"
  license "GPL-3.0-or-later"
  head "https:github.comdiamondburneddissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cec7a220a9ada73feb12aeb96037eab4113e68ba9134f6171092a4a225138bf6"
    sha256 cellar: :any,                 arm64_ventura:  "8f1fa3f7446707860c33877dae7b055dfa1bf6d15dc36e359061e114823dd8b4"
    sha256 cellar: :any,                 arm64_monterey: "b4c4d7a478db3eec0bc75523e3c4878d4bafa87e7aa42d802fa5a2900cb92477"
    sha256 cellar: :any,                 sonoma:         "4101962bedd640a08233f5b3b0b14bb050454261a7eb3fdc64819f7fa4570a20"
    sha256 cellar: :any,                 ventura:        "4337f62e65e9edc52d28e287077856a5f0185dc90ae68e4c66caa1a0b48a505e"
    sha256 cellar: :any,                 monterey:       "afde0fb23d8be3fb1cccd6e6f1964475662c637f6b0119c1f30df6aabf2b4703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9137461cb7a515c27a1f8cfa703e7ae92b0f560fcd059d1fa8e8be42b95f3d4e"
  end

  depends_on "go" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # dissent is a GUI application
    system bin"dissent", "--help"
  end
end