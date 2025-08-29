class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://ghfast.top/https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v3.9.8.tar.gz"
  sha256 "492e3c230c2a0cf82d89cf72ddcd4ae248b93d7a7fcbdc8bf387d3afb9155285"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd05748c75cf57ed9df636aabe367cbe5d082a33435e5223b431ac24d8086c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd05748c75cf57ed9df636aabe367cbe5d082a33435e5223b431ac24d8086c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd05748c75cf57ed9df636aabe367cbe5d082a33435e5223b431ac24d8086c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e0776693a793383d809a5864a59dbe74ff23007e7becac3ac6a849670c5890c"
    sha256 cellar: :any_skip_relocation, ventura:       "5e0776693a793383d809a5864a59dbe74ff23007e7becac3ac6a849670c5890c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7bb85fc637dcbd78ed9877d8664e1d27ba2652e46f5800ee7369b074f21ca89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_path_exists testpath/"test.txt"
  end
end