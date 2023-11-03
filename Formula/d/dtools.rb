class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://ghproxy.com/https://github.com/dlang/tools/archive/refs/tags/v2.105.3.tar.gz"
  sha256 "1d6b52874f42f8795a3dd7efb7499a4338f22b8f2fe85dde92d520320aefe53f"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79edeec30faf03f99a4084474993b886af6a306fb72035a91323c331184792ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf907d9f07544de164c133d53021f43ff6adb63e6b28e969e23f337d9b12ff7"
    sha256 cellar: :any_skip_relocation, ventura:        "7d38590db341ff81b5135f483ba75288c91bc95e85f9d40544631ed55a4af9f8"
    sha256 cellar: :any_skip_relocation, monterey:       "b10ef61effb7ca7e76f24e709c40cd695ef9293f6328eeba8258eb9b41e6c63d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b64ea0081a04316b9108b0596a3bdff6f39253643f811a10e809fb797535c68"
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