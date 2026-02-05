class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.1.01.tar.gz"
  sha256 "46ebeff6996d0fc1fe2e8f0b45a320abf05da6cc0fff6826da4df2735eea1395"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61aefbe057bdd037d4466e9a1c2a9ea70a7f5c3858e063cbcb4f5647334aab29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86a8479acf746eab3f04b50c3b0a5b837b4c20446bfd3f6581ca2da67940593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f335e6da7fba884c01b15721e7333d6413dfb30d848387745738ccc84333ec6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad6a8e1b67d7a5f6333752d8873f2bb4e949aa30864a9f697e6a341d75c869c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "912f024ad4efeb2a21e8ff82b7c1530ed3846d93493a01d21f9a50e122ed68ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946d4484bc178090eba6938e11435660d09ee243cd921e1a37d446b2fd14420c"
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