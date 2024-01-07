class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2024-01",
      revision: "5961d4b31680aa4fc628b85fb49b6f936b3b925f"
  version "2024-01"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd0320d335b9fab66455ef2c1bfefc63f7f4a710b7a3e8b25163bca257c2b62d"
    sha256 cellar: :any,                 arm64_ventura:  "b3346c07f1e418b222b218def0206ecf8b125a175a0c141e88afbfac69fdcce1"
    sha256 cellar: :any,                 arm64_monterey: "4b9f9d5c971d8570a9916ede6a208b620e7bdb82ec066448d25b008e3e80a192"
    sha256 cellar: :any,                 sonoma:         "0c6ebc9b69d2fb0ac0a0d5d37dc14d52ddab36b46df9371c9d21463068477ffd"
    sha256 cellar: :any,                 ventura:        "42e83bcb31c8f22dc7cad97ee746cf74a2f0ae08944a9d18fb177ad7586f8408"
    sha256 cellar: :any,                 monterey:       "80818f3d18f24ff53f1f302c1dc06ab844d04d9e6b99b1864f94cd82805d7436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f9b6d2e5294dbc2df41586d4ac33862c069cda57c737f69c2dc9026be813ee"
  end

  depends_on "llvm"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared"
    (bin"odin").write <<~EOS
      #!binbash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}odin version")

    (testpath"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output(".hellope")
  end
end