class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-07",
      revision: "3072479c3c3c4818b0a41dc2aed288e8b3ec0582"
  version "2023-07"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "528e1c73ccfdd1da8f63afa4ef1c3d86024e3bba641bf051c4214ad4b8e40014"
    sha256 cellar: :any,                 arm64_monterey: "527c2084539f4990b844b6b84b17d907a6812f96217981b1a1ba7b6398581720"
    sha256 cellar: :any,                 arm64_big_sur:  "d0f771a7ee71ee89b63a7b801ef3955bc410d96685274b8a0629605b5a0ac4dc"
    sha256 cellar: :any,                 ventura:        "451988a767244b99078a6dd6b366759bfd00957f0045a8cd6bcbf30434dab2f1"
    sha256 cellar: :any,                 monterey:       "810fa5be383495581f3a92340eadf886afd2edfb744d54e0075e43beadb2fc6a"
    sha256 cellar: :any,                 big_sur:        "bfa44856b5c86c1a7d0b4744074fdcd106466e137f54060e55c95a2e426dd87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d35bd209b4cb05409298948ecb77b29ff2dbc4af9a5baa75afc06ad6fd56f37"
  end

  depends_on "llvm@14"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope")
  end
end