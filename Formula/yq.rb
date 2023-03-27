class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghproxy.com/https://github.com/mikefarah/yq/archive/v4.33.1.tar.gz"
  sha256 "c38b8210fb5a80ac88314fa346ea31f3dc9324cae9fe93cb334cacf909e09bc3"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4442662657887e53dc22ccc802c2ccf02b2a2d4052d4e28512242bcc0f19ba00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4442662657887e53dc22ccc802c2ccf02b2a2d4052d4e28512242bcc0f19ba00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4442662657887e53dc22ccc802c2ccf02b2a2d4052d4e28512242bcc0f19ba00"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5ddda3c8683b101d6055f63093f3f4703a0261ad2a88f13f77490bc70b0d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5ddda3c8683b101d6055f63093f3f4703a0261ad2a88f13f77490bc70b0d7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb5ddda3c8683b101d6055f63093f3f4703a0261ad2a88f13f77490bc70b0d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e9a83a343d95a770381f6faef1b6daa882802667ae6c9ea5ad4b79c7b31e97"
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