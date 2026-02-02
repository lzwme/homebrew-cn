class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghfast.top/https://github.com/mikefarah/yq/archive/refs/tags/v4.52.2.tar.gz"
  sha256 "598ad3719f6b8a199f374baf7a32e9ff527300e56816f4652cd3640c230bf79b"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c32eaf9c17dc8bedd7425698808253844a7667a0b28f9f63de423520a90d95d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32eaf9c17dc8bedd7425698808253844a7667a0b28f9f63de423520a90d95d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32eaf9c17dc8bedd7425698808253844a7667a0b28f9f63de423520a90d95d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5305fc4680d38eb39e2d7b45b18dc5dee3191657d296f4d60591734262d68985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cb6b95f95865fcc575ce43541a4b4a9536333633e4613052d5d23acfff3b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed84420394fc4c6a79df0091a84dad5d84078fff4d71fbcbace8bba264e892d4"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval .key -", "key: cat", 0).chomp
  end
end