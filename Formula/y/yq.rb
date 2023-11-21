class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghproxy.com/https://github.com/mikefarah/yq/archive/refs/tags/v4.40.2.tar.gz"
  sha256 "96c2fdd4881ab21065c5ee324139609870a9b2d84b95abbdf0f282ce71e59cf4"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abcf84bef0f32dd424760266ab685c968ccf7c6ecfb1d29d23ab402ba856942a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0243d0116eb51c6b08c758d07573f24aeba00b618d04283a3e1240fe03482213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b97de2a2da39d88b82800ba69c239f1ffb8e9513d84bb1df443ce228a542e03"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dc43850f05865fca73012374dd8fd813c441e710b9f83c7170a36be4dc7ab70"
    sha256 cellar: :any_skip_relocation, ventura:        "803c456112196f7f8756c47861e9f20fa696af481603676cd4c9a11759df9d26"
    sha256 cellar: :any_skip_relocation, monterey:       "6bfbe33711786c72f4f9e34f8bc8e3951c9d7428e686a05404e51c7abae7be96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf8a4475186f79b74226b9c9ee035965bddf4974f515a74579c597bcba56d85"
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