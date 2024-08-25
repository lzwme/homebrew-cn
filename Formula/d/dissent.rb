class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https:github.comdiamondburneddissent"
  url "https:github.comdiamondburneddissentarchiverefstagsv0.0.28.tar.gz"
  sha256 "fc7189078057db3458bef08aa6d7872018c5c20bf0b21157ca950b8c8a4f93f1"
  license "GPL-3.0-or-later"
  head "https:github.comdiamondburneddissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a6c2ac33b414e7cab554d2e461b487a54490b35c5410cd7ed84512f32b915fd8"
    sha256 cellar: :any,                 arm64_ventura:  "73c8247eff099f913e8c52a165a62e62d69a660b0894e6ca4ab1c1024edaf284"
    sha256 cellar: :any,                 arm64_monterey: "01c6116996a2b58adba2091a107eae030e4afef293476c1656dd8f618e38c5dc"
    sha256 cellar: :any,                 sonoma:         "5acef1b87658d5629c3196623b85b6bc884b832ceb3c2ce8715f804b6309f03a"
    sha256 cellar: :any,                 ventura:        "46544e10af3c0834d37df935856d68cae1381f9e20cc7b60b8730950cc31a283"
    sha256 cellar: :any,                 monterey:       "51e51180295af9bbafc0eeccf01b1f8b5b32e9e40ff65b3f3c605e0af5b9824c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3827fb31f4c844bbd0295935be6a153c6e9deec2996dd0b3031809b3555318"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with "Failed to open display"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # dissent is a GUI application
    system bin"dissent", "--help"
  end
end