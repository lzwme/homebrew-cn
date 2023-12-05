class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghproxy.com/https://github.com/mikefarah/yq/archive/refs/tags/v4.40.4.tar.gz"
  sha256 "ac89c7e33ad6c62985d9c695251f66143562be10a07a2b70d14334aa3b94f764"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c02441af396b711f0cd1b9d50520d9cdd5459577650e39d7220b496227f36e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc3fae00843907ecfecd464ba1bc441225dbf6c8f205cfd5d9454e76c9cf484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6fea0c6462b7359ceb5986c6aed61e0d3fc28f62f507103cae3a48402fffde6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f15b9367e2e83a17ec7405d25bd21e46ed9f7ebecd107d715e017ef6de5e4468"
    sha256 cellar: :any_skip_relocation, ventura:        "9196924c1d86227ab4d2106fa56375fcc17906b68b9631f5380ac485020c0507"
    sha256 cellar: :any_skip_relocation, monterey:       "de5888ecaa50e06fc004d468454a3c4231c9e94c1c68b0ac55afaef5c4657f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361be1295e41d4337aa152cab2258e0d9b40ddb1c96b26fef24a63a7a5751df8"
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