class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://ghfast.top/https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.7.tar.gz"
  sha256 "ac5ae9507edbcd4bba7d652d4849fdc1dd1469d504e6b3514c0e74b50615a070"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7006149ff3de6757812317efb418126206df80e3698735fe0784b5bd6518fbe"
    sha256 cellar: :any,                 arm64_sequoia: "4fa36e2efc607018d783f55ae89c3d2f8bc76bc8ee495a915335a5b8cca4ec73"
    sha256 cellar: :any,                 arm64_sonoma:  "6557d738b0e023ae751f77104202a21d9aca15555ab31fdc75c5204252ba6f93"
    sha256 cellar: :any,                 sonoma:        "453d460cc022d5f5ede9966f6af86d01fc39e9d63c7f44cc73525e732f1bda95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8224ed39649220dd25a69060698f198e2508b589c925eade6f80cc4a1b9f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8255890a67492eaa1554e5f87da53a402cc4a15d003fcfd58d69c2b0de02ef5c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-s -w -X github.com/tronbyt/pixlet/runtime.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:, tags: "gzip_fonts")

    generate_completions_from_executable(bin/"pixlet", "completion")
  end

  test do
    (testpath/"hello.star").write <<~EOS
      load("render.star", "render")
      def main():
        return render.Root(child=render.Text("hello"))
    EOS
    system bin/"pixlet", "render", "hello.star", "-o", "out.webp"
    assert_path_exists testpath/"out.webp"
  end
end