class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.107.0.tar.gz"
  sha256 "e87c63ab39ebd4b98bbbbfc70ade328747383cc1cc410b9d29edb94b46762c1e"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f58f6d5733060dfe8cea6386e90e48b72b7e9d0828e66e41de0d0288b9875202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451bbdb81f5a3a92bf56c8e820afccb7da1274e0ba4c17fca6536bb3fd1c98e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f151e38103635dac6c9dbfde63258dfd9908dd67747fee58ef685bf281fe2e90"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea6b30375813c131128232b2525dccbc5cbb747954d15d25e2644a8e4477c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89f10ce08111e8cebc43ce73d2b79cf7aae60eb93b75436aafd5487b6dde8e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f3798a609b8da99062434cbbec500d30042f315a235e694fb5e3046945d0157"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end