class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://ghproxy.com/https://github.com/ouch-org/ouch/archive/refs/tags/0.5.0.tar.gz"
  sha256 "79562550203d76eecbc7ea47b80d37cccffe08d16dd7a29ac248d38e48c20580"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24264042ae8e5e296452bc0408dbd2b3418c6ed9cc96becc9ab41ebf34e2d567"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8bc7c4e8978293c7411aba396d9427737591d5d48b4350fd7051aa6aa79f587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258b0f30beacee4d04dbafd002b6f28fc96dfc0c4f2a552c8894cb9ff3846b69"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bbde75106968d12099e97728773917daf16798a88ba7079615ff0b5e21de4d0"
    sha256 cellar: :any_skip_relocation, ventura:        "d3e5c0748030e21b408264ab969d129967340c16dfa295ecf0c73a03e37468d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d189f61cce4f186837aa9c41569cdcf406bf5c7918f8d4a93e7f2c283456edb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7f1895de3beeb0239c9a079fe199207c3884a281223d8302a117217e213972"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file1").write "Hello"
    (testpath/"file2").write "World!"

    %w[tar zip tar.bz2 tar.gz tar.xz tar.zst].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_predicate testpath/"archive.#{format}", :exist?

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"archive/file1").read
      assert_equal "World!", (testpath/format/"archive/file2").read
    end
  end
end