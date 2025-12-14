class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://ghfast.top/https://github.com/amterp/rad/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "763c4a1787a3e9727ebc1337d320c871315adf5edf74e63a3a688047d9f5d305"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "028ee1954b2221181986a3827a302fb09aad744b5b768c968f2921a0909f600e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59690c6570abc602830838c1a127ff9d93b9af99dfb7901f80cf0812ce68393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3664ab74caa650e9cdef4f36c31aabd1c5547a3ed142d6e63e2bb237a61f7271"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad438a9461fed6fcf121360e4dbf789385a73b8c37d32410c30059767717db83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb5fc23cfe3ccf23481e0c2f0a63f6491dac6557cf5c434fd643494c6f01c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ba74c8df51c63eea339920f868d92c414fce88d13c7111163c88bb737bc9130"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad --version")

    (testpath/"test").write <<~SHELL
      #!/usr/bin/env rad

      args:
          times int = 1

      for _ in range(times):
          print("Hello, Homebrew!")
    SHELL
    chmod "+x", testpath/"test"

    assert_match "Hello, Homebrew!\nHello, Homebrew!", shell_output("#{testpath}/test 2")
  end
end