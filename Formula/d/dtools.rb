class Dtools < Formula
  desc "D programming language tools"
  homepage "https:dlang.org"
  url "https:github.comdlangtoolsarchiverefstagsv2.106.1.tar.gz"
  sha256 "7c85679167fc9166c9cedf2e14e887279bb49c20f5dc4f299b2ee0eb40932440"
  license "BSL-1.0"
  head "https:github.comdlangtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e29d504218833efd53d7d89d02e4210a725470180c52bdfd9e94c166764b42f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed10c81228380ca8265e2c8de4436de0dd82dd5489069f7816c248663ea4e019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "311fdce3dd185c6ab65e49def2e331c064ffa95f418aee566d2dd4c97e8ef3e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "72b002ce0fac115681b61548282b70893af30c8ba24f8293e1c8ff298f1b5a29"
    sha256 cellar: :any_skip_relocation, ventura:        "658c21ccf3078ff34e119c580e0ab92dc6c4b0a916d3028ce8e855cb7c64ac4d"
    sha256 cellar: :any_skip_relocation, monterey:       "84fa911fcf35b58cd6710d7cdf73f38c0b34aeb6da8f9855cb7738cf4c0ed84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2073138c160f483db7a2bc8d760d9f84fb9a313d5fba8cda555e72ba350eb035"
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