class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https://snowballstem.org"
  url "https://ghfast.top/https://github.com/snowballstem/snowball/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "e49fa0a641be9b93d6b4040785007e82d7b5c74eaca51a6d40e47b516a528927"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8832e3a8b61dfd5eab2e1c6b5ea4e4dd0924bb4863e7ce9a2238361f9c83547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817a7892a41e2be04705b07f92e6bd252ab150e67df1300ab7ba9ec9afbe2c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0832bda4060bb98c1117f6c837cf124d82fa12c4e994c7c01e5eba80a0bd36b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b21d0a40c0fec2d7f9b00e7617960da1ffc55e5ba7db78da03d4f43e59356b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c931ba1a4017fed2ccf0448f78340a04440d5d0bcdf0a9e8082f379e995aa60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e107b0c82bc1ee45569e2cb0d8de09abf62e363dd45756d1b2b8652a4382a321"
  end

  def install
    system "make"

    lib.install "libstemmer.a"
    include.install Dir["include/*"]
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.txt").write("connection")
    cp pkgshare/"examples/stemwords.c", testpath
    system ENV.cc, "stemwords.c", "-L#{lib}", "-lstemmer", "-o", "test"
    assert_equal "connect\n", shell_output("./test -i test.txt")
  end
end