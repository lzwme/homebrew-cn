class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https:snowballstem.org"
  url "https:github.comsnowballstemsnowballarchiverefstagsv3.0.0.tar.gz"
  sha256 "4100b983cec95e1e6c998ea57b220d235f082b9ef6e837afb97dee0bb0a65d14"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f800d74cc3e5337071d2bb59a39085fa36af75fae8b2f00cffeee25fc0dc6d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a4becde03a59785d32e2e4b8fed9b079ee9f6cdebb5fcd4e89a3210687c163"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2595984accd236f401f4e0f37a2cbad5260d7afea79ac55b0182c6630cb72ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d328109b67b97484f0570d86560c3086952f638da20d181cdbb5ffed10e3852"
    sha256 cellar: :any_skip_relocation, ventura:       "73a1328a2b670adc21b014aab0261fa393d2a3de2a5acb07f28c321f2b0472a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070310bee31cfcb3dcbf59b4fa5c9b05c3ada77f33fd096c5a1281e17741f2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d8beb30dbbb73efbf7727da953b2a9d2c2b3bdc74814ea2eb6da54f5e3a0684"
  end

  def install
    system "make"

    lib.install "libstemmer.a"
    include.install Dir["include*"]
    pkgshare.install "examples"
  end

  test do
    (testpath"test.txt").write("connection")
    cp pkgshare"examplesstemwords.c", testpath
    system ENV.cc, "stemwords.c", "-L#{lib}", "-lstemmer", "-o", "test"
    assert_equal "connect\n", shell_output(".test -i test.txt")
  end
end