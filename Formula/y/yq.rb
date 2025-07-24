class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghfast.top/https://github.com/mikefarah/yq/archive/refs/tags/v4.47.1.tar.gz"
  sha256 "48ef09b9ffdb80f26ee516fa2fc83f713c1b49f503cedef79a96435509d456af"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ca7f0398442a8c47b86296323e2c43dc0bf2caa88f899ba73f95ca2ba08fcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ca7f0398442a8c47b86296323e2c43dc0bf2caa88f899ba73f95ca2ba08fcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75ca7f0398442a8c47b86296323e2c43dc0bf2caa88f899ba73f95ca2ba08fcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb37dad2aa76e132551dec38bd1b06402fcc4e8841e59fab4dcaf0081f6eae81"
    sha256 cellar: :any_skip_relocation, ventura:       "cb37dad2aa76e132551dec38bd1b06402fcc4e8841e59fab4dcaf0081f6eae81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571ef29381da2f33fab56810a67a61d9ba68b22c6910c124afdb5d4a5b04884a"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
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
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end