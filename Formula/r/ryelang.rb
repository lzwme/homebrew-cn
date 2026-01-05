class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.94.tar.gz"
  sha256 "e5e9a5974765d3ba7e922427254a726883d7434acc25f98f9b6081ecfbc53155"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1516a94ba0a2ec5dd2b9b2c9fc28a3a005d42b22dc507f62368c061c9638b752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8564fc0deefd7e09e50f9ec1df6666fef63c6c6744b4415811641e063de8280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58925a724b5bd41ca0f0a479b6a371fadd9ecec7f1cab64375190be0f916bc05"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe52634430967027b458c9f824635162a9a69d7ff3b8fa58912a286126c73230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2676936250008e5d67f727d06c9e063366d02fd15fc569b71eb51e09e7436ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7117f93fe0ccb7c930b8228af6daa6aea609984b8e6092f361ea8f4ffdab70fe"
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