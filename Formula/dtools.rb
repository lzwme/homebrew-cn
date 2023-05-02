class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://ghproxy.com/https://github.com/dlang/tools/archive/refs/tags/v2.103.1.tar.gz"
  sha256 "356a71d259524a286d6bda1a97dc33a0355e90ffc4a7c72b31d3514a149351e6"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6785c9695729eb3a8367cec06a93b5b54a10f74a9f65277ba66c4cae8d28810b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8600b33ef4b8727742650e83414940af4b8ea3018d6eccd497417e1c7c42f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca39c67208e965bcac032f2722ccdf1f4ecd0ee1c1a492ba0f73097b6a600582"
    sha256 cellar: :any_skip_relocation, ventura:        "ddbb711f08620f6c5e04e3382bc443d3e67cc53b90611cca15242f5607fa8116"
    sha256 cellar: :any_skip_relocation, monterey:       "bfeeb6a4bfb953ebad2dd679accd369ccefad5e0829bdb0909a8d37e510fa567"
    sha256 cellar: :any_skip_relocation, big_sur:        "127e04342f9dd337580ed4787f7f59416d35b1ea46f6fc520fc37ba9da237de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7fb7a3fdc2b922c5ae5ac629ebcd0d2688d59267bfa5fb07158039a5de0690f"
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