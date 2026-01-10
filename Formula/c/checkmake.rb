class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://ghfast.top/https://github.com/checkmake/checkmake/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4c45c5eda4d22b1b603cad7836805927f047ca5e3a88fbefbbf1a636c87495b7"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b356d80755d1ebde3985e45a45e04b31099ecf331d8fe62b43f08c3a58d389a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e0d43b2fe578c569af32e37643a2872f798b75664895e527a7c9c9c12a5244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4063c62653908758f99a7d2510a2283747f18f300c0d508e5e20a539d672210a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a6dbf5bc7ffee2a1cd8c1cfa71f8c67eb1ad9cf782bae335c1e2fe1c57b064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a463bb5cc4a2e1c1c2d750bf3acfc749f10b75dd30f1a46d679109e0bbbf8a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf3283cf437a78fcc85460c311c110b16fb4513acbfaea46bbad21ab3df500b"
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