class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.25/fossil-src-2.25.tar.gz"
  sha256 "611cfa50d08899eb993a5f475f988b4512366cded82688c906cf913e5191b525"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4abf6653c8cd939f8171f95453330bc2e4439767f4b78676f653b83f06fe8a7"
    sha256 cellar: :any,                 arm64_sonoma:  "f881ded2bbd635a81e887032669862624abf09cc9ff55e75f3555d339bf97e6b"
    sha256 cellar: :any,                 arm64_ventura: "b352c541a28f690ad7372a6fed1705a88c64c96cf916e2d4ff213e622d7a0375"
    sha256 cellar: :any,                 sonoma:        "f42cb6c3e9b92de4fe063b03e11c0dd4172685674a83fb979d6f3b9844f476a4"
    sha256 cellar: :any,                 ventura:       "5ac1165bf2d9ab8b48e381366352d75c56dae82c1281f880543a4223ebafaab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2813cf9265f20b08b1cacc05ab6d884d1c8ed0b16c2b3e3d5577779e637097"
  end

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if OS.mac? && MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
    bash_completion.install "tools/fossil-autocomplete.bash"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system bin/"fossil", "init", "test"
  end
end