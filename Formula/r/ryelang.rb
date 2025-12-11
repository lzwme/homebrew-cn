class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.91.tar.gz"
  sha256 "97dd88e73bf7bc3833af006fb44f534487eef84f819c9efe04c4b75aabccba94"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca07a1fce29392609e3918892718ef4152f379600033ad387a71a5bb3f78e7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94398cde13393455f6982c9c559ffafa42e12c42d4157c404e68fa53c73de4ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae668585db59300f2dd5656b8b543f355e6890d0b9ab968b6beb38eb7a47d89"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fbe0caedfec782b4999425c43d0564ab1832e87450c9d1f607bac070db100f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f3759371d77e7d961edac2236f85a53c6a66288b00f8b062cc7e3f58926ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576bbedd504f691265d1cd4fea9675c4a73a9e194ee68dbd7d020469f65f0893"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end