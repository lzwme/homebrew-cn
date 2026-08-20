class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghfast.top/https://github.com/mikefarah/yq/archive/refs/tags/v4.53.4.tar.gz"
  sha256 "49ddc4cad1682c46d55d5775f5381ea4daa25833665e98883d4a9483d3159e17"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bffbe1012ae6b0c95b57f5df26bf1104b63441b2cf25cf2497e1f2b52197a5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bffbe1012ae6b0c95b57f5df26bf1104b63441b2cf25cf2497e1f2b52197a5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bffbe1012ae6b0c95b57f5df26bf1104b63441b2cf25cf2497e1f2b52197a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a351e2cbc542872b496411cbc9abcfec40fc732354248422c329ef8d13568939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25238b3572ffc41b64ef5e983ac89514cf12432d1ecc784be3a76f1c5bba887a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e852ba1d3f9b824a8983ed2b8cf32417bd458ed7d95a195eee345b2110fa8954"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args

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