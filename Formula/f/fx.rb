class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghfast.top/https://github.com/antonmedv/fx/archive/refs/tags/37.0.0.tar.gz"
  sha256 "75c8c360bac4bccbab85b4873b7030a4ed88d8d4a6e718a935851be6454fe56b"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46d824809e86a85bbb1276c09c162ed9ea3dec022dea146dce112563c897408b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46d824809e86a85bbb1276c09c162ed9ea3dec022dea146dce112563c897408b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46d824809e86a85bbb1276c09c162ed9ea3dec022dea146dce112563c897408b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39294563af592665ea4ec02bce395466d501084d671444286e0dfda6afa2bd0"
    sha256 cellar: :any_skip_relocation, ventura:       "a39294563af592665ea4ec02bce395466d501084d671444286e0dfda6afa2bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4477b6f9e8efc10e29412c8eea8afebd422c6b8f0ba83977fe4650ec7a2f8d32"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end