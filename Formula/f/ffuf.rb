class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://ghfast.top/https://github.com/ffuf/ffuf/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "ee4861be87df612045ace6feead2d51aa5ba6d5181d98820e2ebdb3ab09baa4f"
  license "MIT"
  head "https://github.com/ffuf/ffuf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "928a23b954060dded0edae4936fae9ed4c0fc18158554182b1667bcd2387e4ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "928a23b954060dded0edae4936fae9ed4c0fc18158554182b1667bcd2387e4ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928a23b954060dded0edae4936fae9ed4c0fc18158554182b1667bcd2387e4ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c038a8d8507566a4b326c3a22e9f1f65cebb66d93643a64b14a0ca2a4593ecad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24c233103f2c8aae17f5ac256a5dae36f104d2f1ba2bbfb06b5c3c7e3a551720"
    sha256 cellar: :any,                 x86_64_linux:  "0ba07e5d881617b9359764eacbde58cf7ff2a5ee9ffccee5017bc40745dbcdd0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end