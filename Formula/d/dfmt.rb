class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https:github.comdlang-communitydfmt"
  url "https:github.comdlang-communitydfmt.git",
      tag:      "v0.15.2",
      revision: "d8e43e23eca0aa32f064fe7efe8e74a9efa8018e"
  license "BSL-1.0"
  head "https:github.comdlang-communitydfmt.git", branch: "v0.x.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2af58c128ce261ec39dac434a43d3f7247470d53da99f794d878943dec5fc285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef439a3078bc2ee16955a840b26f9262b41d20909ba0e5ee607c3d07e2824c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922bbe6012dbac27a2e65c4d8b1b8e3e7485299005e371035109baed9435fce2"
    sha256 cellar: :any_skip_relocation, sonoma:         "44171bb99b1902f7992a8a2f0bfd3a420f78c4d432cf63e022bdddd0c8f44909"
    sha256 cellar: :any_skip_relocation, ventura:        "a6395124d210dcf1ee14f282d0a1a9a94f46e620e4fbc8fc909197a2c8d49d90"
    sha256 cellar: :any_skip_relocation, monterey:       "67a53f11863df3acfad33a1aa83f7537222e24dfe4b3bd7b64734dffe66ad612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c388fa11efd8c658e529ec9279a87930751226248893b198de70abd6fbcfdc07"
  end

  on_arm do
    depends_on "ldc" => :build
  end

  on_intel do
    depends_on "dmd" => :build
  end

  def install
    target = if Hardware::CPU.arm?
      "ldc"
    else
      ENV.append "DFLAGS", "-fPIC" if OS.linux?
      "dmd"
    end
    system "make", target
    bin.install "bindfmt"
    bash_completion.install "bash-completioncompletionsdfmt"
  end

  test do
    (testpath"test.d").write <<~EOS
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<~EOS
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    EOS

    system bin"dfmt", "-i", "test.d"

    assert_equal expected, (testpath"test.d").read
  end
end