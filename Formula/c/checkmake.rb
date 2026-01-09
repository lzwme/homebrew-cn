class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://ghfast.top/https://github.com/checkmake/checkmake/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "37f14cbf37135e3c7507b990234c4fdfd9643d4227924541db901b84a66dcd14"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20eb1f2b1bd0712c1faf5e1894c4c9e8807f8f3b9057997ab77c3b6afcf11803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2671c063f1de1df73c0a878d3dacb4fcbfd562da98ab8adc411b3408d7652161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6861c1acb385360d905769ae854d5ddebbe8554bbaed1ee165f9a8a6c06c16c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b8950eed6254cc674ab0d8748d6c102c1d81ba9265a127f4a7b9fc7bb6a8d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d6415b50e45cafe74c342e668ccaa7e8b92a159f16f6414e6cbab1e0734605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf6346c8e59fdbe229ed6ce6763ce0d48f1b9428fefb17027723847bd76a868"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["BUILDER_NAME"] = "Homebrew"
    ENV["BUILDER_EMAIL"] = "homebrew@brew.sh"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    sh = testpath/"Makefile"
    sh.write <<~EOS
      clean:
      \trm bar
      \trm foo

      foo: bar
      \ttouch foo

      bar:
      \ttouch bar

      all: foo

      test:
      \t@echo test

      .PHONY: clean test
    EOS
    assert_match "phonydeclared", shell_output("#{bin}/checkmake #{sh}", 1)
  end
end