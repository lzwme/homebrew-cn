class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghproxy.com/https://github.com/mikefarah/yq/archive/v4.34.2.tar.gz"
  sha256 "035b7e827eccc66907270ff7f0d35c7917d56ded4aff44f7b942fe4802b70d01"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f541a0d6e71baceccfef6f309581ab5baae0c8e464f6e4f3fa59bf21ce87cee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f541a0d6e71baceccfef6f309581ab5baae0c8e464f6e4f3fa59bf21ce87cee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f541a0d6e71baceccfef6f309581ab5baae0c8e464f6e4f3fa59bf21ce87cee"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ccd7d1a0b182a225d1a151f5f9692aba4f8c69e1fcf41d04b6d383128cf407"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ccd7d1a0b182a225d1a151f5f9692aba4f8c69e1fcf41d04b6d383128cf407"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ccd7d1a0b182a225d1a151f5f9692aba4f8c69e1fcf41d04b6d383128cf407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3620d2b3f41c3155675a2cad2db721d4cacaf343f13d852560e9fa7571b78bc5"
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