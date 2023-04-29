class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://ghproxy.com/https://github.com/dlang/tools/archive/refs/tags/v2.103.0.tar.gz"
  sha256 "591bf56d7c8aa45205a3533438fef5bd48007756446f5cf032fcabcc077afdd1"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da384aaa300b1648c3a70e6463d2c641b00a13be22faefeaf4f4dec6130cf151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c6a4a0b5bad3798f2053e3dca62252794653495d94cf52c3486e8aef573752"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5df4564d0f6e520ef2b26b7fa45f731665d76160ce14fd8994348d2467a00e16"
    sha256 cellar: :any_skip_relocation, ventura:        "0c02f89a54244c2bdfdde3daf118884a42aaa34c3baf67653defcdfab6405849"
    sha256 cellar: :any_skip_relocation, monterey:       "4ee28720d94f43b42b3587f64544149324b92d3045271a53536a0cecb3a5c9fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "be2da167f0f3dee53712e3ef5f8674eba2ebc17ef0de5f63afd4c69449fe7cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d05ff8532ac2cc4eb3d6b96ff4b175ec8a7e2b5f4f3f255b46de05037791cb"
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
    tools = %w[ddemangle rdmd]
    system "dub", "add-local", buildpath

    tools.each do |tool|
      system "dub", "build", "--build=release", ":#{tool}"
      bin.install "dtools_#{tool}" => tool
    end

    # DustMite is not provided as a dub target
    system "ldc2", "-O", "--release", *Dir.glob("DustMite/*.d"), "-od=build", "-of=#{bin}/dustmite"

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