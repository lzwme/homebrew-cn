class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://ghfast.top/https://github.com/dlang/tools/archive/refs/tags/v2.112.1.tar.gz"
  sha256 "fe887bd938ce8add519b27e4a84311ed20db74e6c22bd402a99693753df73d9d"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "903e7b80fc375d8c2712aa402213d64e5a2e0ef2a10f2dd68d90ee47266bad51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec9a3d1142666ab608f8d5afd64b7f1279d2c362bd7b3e402ab85be657be9e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f332ba205c3dd84c366c9123e4a8fc6f6183aba5a7acc430713561b6a8edadfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfa5f8ad8df8f6146b5b0ac6765a8bdb0f1b9e068ceb8a4533f4dc0037cbbd6a"
    sha256 cellar: :any,                 arm64_linux:   "c7404baed6540d42b1bcda1e4924f531d593d7be12460150bf2c2ff230e09b27"
    sha256 cellar: :any,                 x86_64_linux:  "c3f51aef205998c21563cfafa5dd88767610bad22678737468898aee4d9a87d3"
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
    (testpath/"hello.d").write <<~D
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    D
    assert_equal "Hello world!", shell_output("#{bin}/rdmd #{testpath}/hello.d").chomp
  end
end