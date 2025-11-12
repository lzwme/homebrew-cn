class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.88.tar.gz"
  sha256 "66968b115098284d43d01a13edddc8a005018aab09994cd2f9a74dae157b6500"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd80db2e9411d7248f898f9b8927ae22ba2e4a35bd7135230ccb6b397246f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d99b9b5ac24469f804252c746649044e21975ca06659736195fce2b3b4e0982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b9331b90e38e0e00167b6879a9d069ccdb3fe8bbceba769407c77c84bd0715"
    sha256 cellar: :any_skip_relocation, sonoma:        "b703c1bd93be62196cd56eff5de0ea768cac9181fee83d2ff2fca7162909bd5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a00383b3b87a4e46f885ccc1a723d859def4dd1ad050c3362d4a25564beaa903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b99fe339752e47b3990aad7fe9c5d49b578aee8e027e44fe2b289dfb1149b6e"
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