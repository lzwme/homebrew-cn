class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://ghfast.top/https://github.com/tronbyt/pixlet/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "99711b79ee298d93bba7d9070e619c6a6879f5b3dd77a2322be9825748b6fa83"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0f8fe1b8eb10ad2834e877d8deee2b3d7e204250d9a344f66d4e2a0e0ff86f24"
    sha256 cellar: :any, arm64_sequoia: "5ab235c910624846fdc7a223302fb692d11ebf3ded8e743c6c5799409737ceed"
    sha256 cellar: :any, arm64_sonoma:  "d3edc58458a357ab5eacebeefc64314a2212dd6b8d8e38d8d1fa3e2058190e95"
    sha256 cellar: :any, sonoma:        "8da0a3f582dcf7601097c665845044c7a36ab5592059f9a27cc1b511702289fe"
    sha256 cellar: :any, arm64_linux:   "dc60cf7020cd4a81641aeae640670ac4a9bc7523f977ddcd29df38352942fffd"
    sha256 cellar: :any, x86_64_linux:  "4abc3bcf0af08a59aab92e0e6bf99ae2e27f2ddbc39844bc979b91efe3770d78"
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