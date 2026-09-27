class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.37/gtk-doc-1.37.0.tar.xz"
  sha256 "2facfb530ddcd20c03ed4758ef934e832626c393e2cacd23fc1249b7ed0e4246"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d1898204cd8ca31f070f6330031edd3f1dfa73dc9deba726bc70820bba45f25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c60299b698203012eca8ba77eb2ef628e2e9a49c76b3fac7f649219e090723c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb13c51e5ef584c0088a2a9696ca55ecb304bb281503aaed354c4be0f8321080"
    sha256 cellar: :any,                 arm64_linux:       "8ede875de3135522b871f54fe7898a712d39af955a3bf42db0a8aa9e68b0786a"
    sha256 cellar: :any,                 x86_64_linux:      "85fcd7f3589814d422c46975c53a1b1e187b8187e07a4a2f693b4075555cad88"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: %w[lxml pygments]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", formula_opt_bin("pkgconf")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", "-Dtests=false", "-Dyelp_manual=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end