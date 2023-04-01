class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghproxy.com/https://github.com/mikefarah/yq/archive/v4.33.2.tar.gz"
  sha256 "eea0435bef57a4523dbbe3680fafc321d821986a49a92af69b0c637a428d454d"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bc87888417ebb090d6a4343612a5b671b65a7f09bf5b4ef38f3b80e7b6e8037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc87888417ebb090d6a4343612a5b671b65a7f09bf5b4ef38f3b80e7b6e8037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bc87888417ebb090d6a4343612a5b671b65a7f09bf5b4ef38f3b80e7b6e8037"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd42e767538b85111b2e10de9b37faacad3540d47816884c0515c8fb9ebae82"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd42e767538b85111b2e10de9b37faacad3540d47816884c0515c8fb9ebae82"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cd42e767538b85111b2e10de9b37faacad3540d47816884c0515c8fb9ebae82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98efe99a7ced2c85c184b3e021faf0d413a53cb690815fe99f0df5c07616e3d1"
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