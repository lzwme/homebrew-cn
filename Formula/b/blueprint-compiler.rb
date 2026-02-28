class BlueprintCompiler < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://download.gnome.org/sources/blueprint-compiler/0.20/blueprint-compiler-0.20.0.tar.xz"
  sha256 "ec786d66f583e8296c845f1f82834d27b369f39d55a6380b34880493e22db382"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "deb86cf728441594bf863fa9bf2c46285ca9819242020e8721b9a327e988a683"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk4"
  depends_on "pygobject3"
  depends_on "python@3.14"

  def install
    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)

    system "meson", "setup", "build", "-Dpython.platlibdir=#{venv.site_packages}",
                                      "-Dpython.purelibdir=#{venv.site_packages}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"test.blp").write <<~BLUEPRINT
      using Gtk 4.0;

      template $MyAppWindow: ApplicationWindow {
        default-width: 600;
        default-height: 300;
        title: _("Hello, Blueprint!");

        [titlebar]
        HeaderBar {}

        Label {
          label: bind template.main_text;
        }
      }
    BLUEPRINT
    output = shell_output("#{bin}/blueprint-compiler compile #{testpath}/test.blp")
    assert_match "Hello, Blueprint!", output
  end
end