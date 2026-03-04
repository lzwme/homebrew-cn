class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://ghfast.top/https://github.com/tronbyt/pixlet/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "360cfbd92fa9c49fa0bb8b04327c01e9860528c826e7bbe640cf541aae9fa25b"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32cff6f28932c6339f428642581a86c69ffdbf4725269d2bfbdc01709e280fc0"
    sha256 cellar: :any,                 arm64_sequoia: "57a75331d791fd3dbf97d97115cee8c00809a7d0c74e5f7586eb02f732f2c5ef"
    sha256 cellar: :any,                 arm64_sonoma:  "ac8d07ed27035442670cb35cf35541e8921465fb24e108888574da7ea2888ab7"
    sha256 cellar: :any,                 sonoma:        "c5998d34207824c18ae7db70bd985ac30dc38c1f3a21e0073792d650646bf6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0577d87c437e33d3ca01a52ba7d263b5239168ec5a8a1ff2ed244cd164ddc4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f93d0e126879b8b178eb6339e55b8ca6635e8acaab940991fd557973ad313e"
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