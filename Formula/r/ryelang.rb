class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.51.tar.gz"
  sha256 "5bcc98fe8abe9a276ca932447954879c5fa40ef134ccb077ec25cfc4015eddee"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "072e3e9c8944a74e67b711ae634f9659151c8c496754019afbe4f29c9cee8d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d632a42c68230f13aae94a59753d1ee40b4c6f6a24300ecdd5ece6297b871ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c24f535c3d5c9f97b47195c47ad83334a8e148c2f8de897f0aecdd8e2d13a78e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2a40ce50593e6d20ff753500baed9dd8ae99216f0fd1ebfc90c86d6d4933a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "665ee3a0756e570ec9dad382f79fbe41069146bad0645c9d44e84eaf7cf1dba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c10bf8ecc864d459cdb485245cd9034a4a9cb7ebdd863fdb5668de1ddee30b0"
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

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end