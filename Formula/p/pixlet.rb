class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://ghfast.top/https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.7.tar.gz"
  sha256 "ac5ae9507edbcd4bba7d652d4849fdc1dd1469d504e6b3514c0e74b50615a070"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9d3cef5a781a01a23498849010f1e2daf91e2d0ab26f421c43a49540fadfb192"
    sha256 cellar: :any,                 arm64_sequoia: "10b23c97730f2f6c90299f0a1fa19073733083b73bab1b2352f045fb1d171801"
    sha256 cellar: :any,                 arm64_sonoma:  "6e45d0297a160e2e915262b2b72ed732786d47a8eaf7772a78af88b32b4f1c98"
    sha256 cellar: :any,                 sonoma:        "1f84c7713fa3a47936e368fc6c532ce52ecfb5525721d4098aa8fecd5f829cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f9e7bfeff303c83a3e281846ad237f6a0427173fec32963cc3507602b6baf87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad756e05ff556d9d75ba54371e83388aa0434c021c56623d0228a9ed605f5d7"
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

    generate_completions_from_executable(bin/"pixlet", shell_parameter_format: :cobra)
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