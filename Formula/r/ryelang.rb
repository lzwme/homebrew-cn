class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.87.tar.gz"
  sha256 "646d9d77eaab86b76b606e2638d0a41e2056fc8e500f04e1a29c0c0ef2ceb479"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be783ccfb3319bf70597ebb0c1a7da4b11350250471309f84148f428da049bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb8f9bcb6e92c6da715d14a64bc4975d9e4a6e3f382377b3af845e0dd68c1755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042cd5cc4eb87e0b2e6ab72aa05de0210f8e581ec30e09e877cc133439a1afec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3d9ff048a372a6a2aa72bc255ad1c4074f605b44fc0b9783a4a75c8679a9fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0529623995aa040a3042dcdf3d8ca834d7b7fa0edb8cfa6a130075c8111b132e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d34bb96d64e0f4af15080c3ecbd7f3fe348b0df1b091cc805ec5b86297f950c"
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