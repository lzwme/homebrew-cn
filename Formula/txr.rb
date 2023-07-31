class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-290.tar.bz2"
  sha256 "72b4a8db1dd6344e907000f5f149f9fe3ecf0cd8480648f039ca24d06cda2262"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf895e7d8279221f326be42df88ed5312e9fb35fbda611c3fbe5b24c99920990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cbbd5cc374d0f77cd4cb8827254b888a7f3548fd9edb703d643c1d9746ba1ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6fbd7fce40f9bceacc0be229943429d5ae4176886605deeabd315919f70e1e9"
    sha256 cellar: :any_skip_relocation, ventura:        "feda85aea4ee44205e88d0c7b3b71e225908bb9c5762ac7f76204ec08639a351"
    sha256 cellar: :any_skip_relocation, monterey:       "a0667a938c7d7a933a73c4593b1cd8c4c3123dc15188566c344fb8748ba94d93"
    sha256 cellar: :any_skip_relocation, big_sur:        "0393be6486645e75b177dbaba476b4e636566d246c1180c72ec940273a5e63ee"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end