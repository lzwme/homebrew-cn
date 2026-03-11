class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://ghfast.top/https://github.com/tronbyt/pixlet/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "fa9c0cf8fd15b31260ed7bc0255af34360978f414744fae76b31446493aa9c02"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "717a462eb7ff00ed620ce43a0dc4d8bd626bcb6087e2551db7f75f4085dfb444"
    sha256 cellar: :any,                 arm64_sequoia: "478b2cfc9b41c4e59f39c9edd705ce85b1e8ef10e4763fc87151a48ffb2f69c6"
    sha256 cellar: :any,                 arm64_sonoma:  "7c03f0ad5d2ee369516e024ba05d71484998f79dffbb4f98f41b8f6221384edd"
    sha256 cellar: :any,                 sonoma:        "cf7d4f21188dd7841668d03c7d6d238137970e4e15f92a56ad96deb7186fbb66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dc15cfd057513b0851b340df65c42a9b18e972f9f65cff11d50f908845c5b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f80fe2e4692c71b0bde31c2073d5b2f816a9a59c325dbbaf7f8b71c817604c2"
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