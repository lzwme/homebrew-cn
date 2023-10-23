class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "df407875150a602d4869d9ac8d1ece690fe4cae5a95bc481fc546085ff8969c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae5cde44dd16ad283759cc92c50db7fb458a54c4bce5998b27a768b255a2cefb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac5472fe12111d09946a68d790b617cc34c758d884b7606a978c1a18aca4db5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad3bbab81af7cb65b9ababc1a4bc7db66bb93613b84c7bf5573eef18279e728"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ebb4eb191484aa39833e600b64e567dcb2753111600210367ef46d4994066ad"
    sha256 cellar: :any_skip_relocation, ventura:        "7ec1965b9ca7d492ee785c848ccc8fea6d9b7b4784899445aa01510f7b82314e"
    sha256 cellar: :any_skip_relocation, monterey:       "b00298ec9d6ae445b1708367b754e02f6678305cbec74e6448eccd3719b17b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9246f990ec95610c33250d658e75ce2ef6bb792ce158044a696c61b4b5c4f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version 2>&1")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version 2>&1")

    assert_match "Wrapping command line to support trzsz", shell_output("#{bin}/trzsz 2>&1")
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end