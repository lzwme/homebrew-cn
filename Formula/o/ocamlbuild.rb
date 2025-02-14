class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https:github.comocamlocamlbuild"
  url "https:github.comocamlocamlbuildarchiverefstags0.16.0.tar.gz"
  sha256 "104fa954c28a6d731674f2844e3f0c87b08db51d38f4ea25f4653bb60ef2e8f1"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https:github.comocamlocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "08cc2b5b68add1540e18daea2f78816ef97d8f3010bf79271eda532a24cf8554"
    sha256 arm64_sonoma:  "64a005e1fb2d0b38cfbce962e7320e2d7ab63f4f8d2eba3c1f4ced0a1db5ad54"
    sha256 arm64_ventura: "6635f2766e9079b483b30dbd39d49af0a1571149e7e3ed86276a2ffb910eba2a"
    sha256 sonoma:        "65c4df3a62eb2d689bdc34e94a0ada93ad2f3d056a23260795f55a0a9410fd25"
    sha256 ventura:       "128d7aead5beb36f0633f3d2ca7374f8c85c5045a9264331a3e91b37567a6126"
    sha256 x86_64_linux:  "d34295292a90e8ee00d73e2d8cfed013e34d676c8032246d9ad5011249c04c06"
  end

  depends_on "ocaml"

  def install
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}", "OCAMLBUILD_MANDIR=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ocamlbuild --version")
  end
end