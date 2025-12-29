class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://ghfast.top/https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.8.tar.gz"
  sha256 "5d8b8e6d1c625eadb7bf9bbf05a557e4fdde2387c56a67a71d765d61ed00e408"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c9efbadd56687a2e8493b3a62dcb159b437b247e9907eb0f1c92b15ad73358d"
    sha256 cellar: :any,                 arm64_sequoia: "89b9c3576f72f547ddcde81b19929fb48dd20cdcd2afe82ab5d0da5c1b1779f9"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f5648bffef74d33a6fee239bdcc086353c0fbed06095c255099cb2988a3fd3"
    sha256 cellar: :any,                 sonoma:        "9a67f6566f17dcc42c3d598a7dd2e9fe3d4ed087494bf42dc896c316ded2277d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f4dffa8c83d18d9dced3b5f1b07854dadd3f2a857e39cf8e167658c0f28e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a59f8ecadd7d539a4437bdb068d19c3cb642783b0d96c5b9af7eae2d8bceb5a"
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