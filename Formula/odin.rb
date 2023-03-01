class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-02",
      revision: "fcc920ed39c706240ef011fdba7fd1442b01b4d9"
  version "2023-02"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8553b9bdc848191c8cc49cc6e11bd53b8692602560c07616a8508f4b4311354a"
    sha256 cellar: :any,                 arm64_monterey: "377774a9f6c133b477326faccfe82aa2681d158118fa948ad230f2087696695f"
    sha256 cellar: :any,                 arm64_big_sur:  "22aef51ce76136ee1425dbf256bd5c52c24d30e2ce223261de04d44de13ff2cf"
    sha256 cellar: :any,                 ventura:        "e3e9e7332d5e3c49075cc9aa2384864b6e93b22094f2668c63452f3c714a7903"
    sha256 cellar: :any,                 monterey:       "47e6032c3ff329c5225e2f9e6ef76831edbc206d0fd38fdc91a2fcf772b647f6"
    sha256 cellar: :any,                 big_sur:        "6f1e90986221997a4d7c65298cb90d35ab2bbaa3454224cbe8ea4e1a4b655277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6759ca31a8d6a50a242e6f771e91394f20f042677ee2be22eb43bc4fdb5e1c31"
  end

  depends_on "llvm@14"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    inreplace "build_odin.sh", "dev-$(date +\"%Y-%m\")", "dev-#{version}" unless build.head?

    system "make", "release"
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
    assert_equal "Hellope!\n", shell_output("./hellope.bin")
  end
end