class Dtools < Formula
  desc "D programming language tools"
  homepage "https:dlang.org"
  url "https:github.comdlangtoolsarchiverefstagsv2.106.0.tar.gz"
  sha256 "78076bbdd77fdd8763ba754c78d543a465b4319a0303e2929cbae99ed48fbff5"
  license "BSL-1.0"
  head "https:github.comdlangtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8976bf8113b454011d4391c0b45a348deab0b1e9b51b929aa14f70319f816333"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f24604ff03f75eb430f8c586ffa7061cd712107e3c8c550e1b8ca0a6ded0c59c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc268cd630580ea4276f1fb38a1cef0de6328adaca64cca367ed15b627262c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "859feb03ce5ddf0c0f1ca2a36f2df82fc47dea42b771d91fc30c86581f5f6704"
    sha256 cellar: :any_skip_relocation, ventura:        "086526b7521ed60dc2d815f49cc8cb099430306baa8d070f89c1086fa9208deb"
    sha256 cellar: :any_skip_relocation, monterey:       "a53d9ed33bb6237c53796e04cba2e4e1406044b2b2888466d2a802103fba10e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefe9d77c01c795d270a528a69db78d6b698cd24327aa618083bad2f1ca3159d"
  end

  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  link_overwrite "binddemangle"
  link_overwrite "bindustmite"
  link_overwrite "binrdmd"

  def install
    # We only need the "public" tools, as listed at
    # https:github.comdlangtoolsblobmasterREADME.md
    #
    # Skip building dman as it requires getting and building the DMD
    # and dlang.org source trees.
    tools = %w[ddemangle rdmd dustmite]
    system "dub", "add-local", buildpath

    tools.each do |tool|
      system "dub", "build", "--build=release", ":#{tool}"
      bin.install "dtools_#{tool}" => tool
    end

    man1.install "manman1rdmd.1"
  end

  test do
    (testpath"hello.d").write <<~EOS
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    EOS
    assert_equal "Hello world!", shell_output("#{bin}rdmd #{testpath}hello.d").chomp
  end
end