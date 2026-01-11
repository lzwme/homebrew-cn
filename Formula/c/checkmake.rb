class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://ghfast.top/https://github.com/checkmake/checkmake/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "450412ba6500ef7c4c8a0150a5e1a3d2e76591ce9f37609bcbd5508298ad9bef"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ca1c4b1a0476638ac6d77ac1fd8382e92ff676868570426c68f806d68bc8fce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b50af7212339c032d4e88ed510fc18190411ec2ede062daf307c9a8175cfef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec784fef942f957b50b11dfce657ea2e42e4b7b49df58e027ec10fff08bf8c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "459e323f8cb533dcead13656a5cdf62baa4ce8c02046cd2e0f216deabe3e029a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20cea79f960a78601f693e52b2f6aa6c8767f9c3dd7eb5a165fbced4874e150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216c1f4df03223c8ce81087dc71c78071263ca6653f6e2e112e13452fe1a08c2"
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