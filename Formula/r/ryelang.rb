class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.92.tar.gz"
  sha256 "ed63827902c7699ba196b13eb03b7c8810f1edfeae893ac9c956dba1526d981e"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f290c4076459fda51a02379be6653602221e9575dea72d6a55afd2da61936c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c631d15e617a30885a260b673d291a2a1120e9ac4d43f3f21c48a792f2d7abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f7e8279864b62d312d26989e44e04d4c30356a0476ed82aeb2f46a5bf89ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e6246fcf61cbfd7e29d47f8c4aae76eeb35460c808d91f96226810c002426b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02815c8538f773e7440dfc6ddb91b0722d3523ceda67fff4698eac372c9502ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7010e325fe9634d18a48edc23744d7f56fb5dc249108c699e36abc47363571"
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