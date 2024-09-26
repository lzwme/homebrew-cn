class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https:github.comacpicaacpica"
  url "https:downloadmirror.intel.com831952acpica-unix2-20240827.tar.gz"
  sha256 "d540e982f1391c2e5ee57c391d73035b40ba4fb2a98cee626db6ed12db59a737"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https:github.comacpicaacpica.git", branch: "master"

  livecheck do
    url "https:www.intel.comcontentwwwusendownload776303acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b31e8c7f95deee0bd189976e2c0a5a97cb11b04a3a3ec436a638b6966ba72422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ace6ea218550e822c41196257feb968d985866d37c7ece028c8b9741c74bfcbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eb8e278dfce3b743399d9ec82bab589fc02db5c5e5ed15dd8ce44843e5942b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b4de1502aff4b2dc06e1e056397f4c013137a2d439b3047d967caaf7182c73"
    sha256 cellar: :any_skip_relocation, ventura:       "1c535e6f6302cf90254d1f89d51e5ba8d082f4cc86d1a8c2a51975dc91dfeab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "332dfe0f91060ad3d0aa3d8ce4b7d747da6dcc77f92b0fcd51f4cdbde1ac4a71"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    # fix acpixf.h case issue, upstream bug report, https:github.comacpicaacpicaissues971
    File.rename "sourceincludeACPIXF.H", "sourceincludeacpixf.h"

    # ACPI_PACKED_POINTERS_NOT_SUPPORTED:
    # https:github.comacpicaacpicaissues781#issuecomment-1718084901
    system "make", "PREFIX=#{prefix}", "OPT_CFLAGS=\"-DACPI_PACKED_POINTERS_NOT_SUPPORTED\""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin"acpihelp", "-u"
  end
end