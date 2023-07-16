class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://ghproxy.com/https://github.com/dlang/tools/archive/refs/tags/v2.104.2.tar.gz"
  sha256 "728c3fca5197c85091a1b95e8fe2f30f9cd7b903cbab415a57264058b861e23d"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "961f55647bd622f99f34fa1a94352fc33a782bba3d42960d2c8482ef71235ec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bef779a5764aea4e0e8f2b564c5b8bb9c9095938c1acf465b048ec7d1a9a822"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25b04db07f35e066fdd9808375aa602063a082edb453f8e4e681c4847fe81d2"
    sha256 cellar: :any_skip_relocation, ventura:        "4c39117867389a640f7120fe9190dd7eb1581c4c7bea29a4194025a72d6e0ebc"
    sha256 cellar: :any_skip_relocation, monterey:       "97a3c6b28c14e25308fc632e594ac41ef8a34c10dc8ab01b51925784137d1423"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5ad537344fb458fb66e61a63c5d8c2996c34372bbee07074caa97e9ddca5c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d7e7ce676e43bb4044567100ab5b1eafaa90a953c58345995f0c2993aeaf3f"
  end

  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  link_overwrite "bin/ddemangle"
  link_overwrite "bin/dustmite"
  link_overwrite "bin/rdmd"

  def install
    # We only need the "public" tools, as listed at
    # https://github.com/dlang/tools/blob/master/README.md
    #
    # Skip building dman as it requires getting and building the DMD
    # and dlang.org source trees.
    tools = %w[ddemangle rdmd dustmite]
    system "dub", "add-local", buildpath

    tools.each do |tool|
      system "dub", "build", "--build=release", ":#{tool}"
      bin.install "dtools_#{tool}" => tool
    end

    man1.install "man/man1/rdmd.1"
  end

  test do
    (testpath/"hello.d").write <<~EOS
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    EOS
    assert_equal "Hello world!", shell_output("#{bin}/rdmd #{testpath}/hello.d").chomp
  end
end