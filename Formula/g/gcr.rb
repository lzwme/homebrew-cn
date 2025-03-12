class Gcr < Formula
  desc "Library for bits of crypto UI and parsing"
  homepage "https://gitlab.gnome.org/GNOME/gcr"
  url "https://download.gnome.org/sources/gcr/4.3/gcr-4.3.1.tar.xz"
  sha256 "b2f070fff1840eef70546a28be80235427c116aadc593b5b68ccc869be3aa09d"
  license all_of: [
    "LGPL-2.0-or-later",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later", # gcr/gcr-ssh-agent-private.h
    "FSFULLRWD", # gck/{pkcs11x.h,pkcs11-trust-assertions.h}
  ]
  head "https://gitlab.gnome.org/GNOME/gcr.git", branch: "main"

  # gcr doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/gcr[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "48695c463b081f11bf5a01d56bb60eff12937d98cec4fa84ab96e68f60978383"
    sha256 arm64_sonoma:  "3fdc72dd94c511e5015848fc98e51a05d16b191ccd655dbfff4d09b963ece956"
    sha256 arm64_ventura: "cae0a6f29bd0788fcf76ddceb83cec01285bb2efe6556161523a6c8eb7852f68"
    sha256 sonoma:        "7b508d0794660e0b2953414f6ef83d26e3cd7811bf77e77a4b9e7f212793645e"
    sha256 ventura:       "07092cb9612568e58f652cf543ee2bfac09194aec8b075ab6611166eb74611d8"
    sha256 x86_64_linux:  "7613ae7fbb8eb5b86076407007ce98992d97dfdee6d7c224ae8209184eeffe42"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gnupg" # for gpg executable
  depends_on "libgcrypt"
  depends_on "libsecret"
  depends_on "p11-kit"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "openssh" # for ssh-add and ssh-agent executables
    depends_on "systemd"
  end

  def install
    # Disabled GTK4 which is only for gcr-viewer-gtk4 tool
    system "meson", "setup", "build", "-Dgtk4=false", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "der-certificate.crt" do
      url "https://gitlab.gnome.org/GNOME/gcr/-/raw/9019498dfef15efec4d12eee8becc55781062a30/gcr/fixtures/der-certificate.crt"
      sha256 "bc23f98a313cb92de3bbfc3a5a9f4461ac39494c4ae15a9e9df131e99b73019a"
    end
    testpath.install resource("der-certificate.crt")

    # https://gitlab.gnome.org/GNOME/gcr/-/blob/main/gcr/test-simple-certificate.c
    (testpath/"test.c").write <<~C
      #define GCR_API_SUBJECT_TO_CHANGE
      #include <gcr/gcr.h>
      #include <glib.h>

      int main(void) {
        GcrCertificate *cert;
        gconstpointer der;
        gpointer cert_data;
        gsize n_der, n_cert_data;

        if(!g_file_get_contents("der-certificate.crt", (gchar**)&cert_data, &n_cert_data, NULL))
          g_assert_not_reached();
        g_assert(cert_data);

        cert = gcr_simple_certificate_new(cert_data, n_cert_data);
        g_assert(GCR_IS_SIMPLE_CERTIFICATE(cert));

        der = gcr_certificate_get_der_data(cert, &n_der);
        g_assert(der);

        g_object_unref(cert);
        g_free(cert_data);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs gcr-4").chomp.split
    system "./test"
  end
end