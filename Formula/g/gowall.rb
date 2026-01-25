class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://ghfast.top/https://github.com/Achno/gowall/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ff5289250cd1bfe7adef728c85c4c97aed906330e9bd79760be540eb49343d51"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36f165943b51f74f40559f425ed5996f9c9d3262b20ddea6a123bdf8e51df68e"
    sha256 cellar: :any,                 arm64_sequoia: "f7efae6bfdb9adf5a0447cbf1399c6daf775bec33a7b6e0990872a6ea9f6f427"
    sha256 cellar: :any,                 arm64_sonoma:  "f7cee542eb1e00cce13bf4844c7c8d21552d8a3ddb7cae6d73aaea896d835398"
    sha256 cellar: :any,                 sonoma:        "6eb2a3474a0202fcc14fce9f33f56bad36c01f5b2493ccf214312625142702f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a79630151d2c632c0227f0241c97e639a1a7a9a008d038f07c871128e8a8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1771c623a8311087e125f2c483f541cb7ad3357cc7db212ad26d4999ed8d1c92"
  end

  depends_on "go" => :build
  depends_on "mupdf"

  resource "go-fitz" do
    url "https://ghfast.top/https://github.com/gen2brain/go-fitz/archive/refs/tags/v1.24.15.tar.gz"
    sha256 "086b656bbb00c314083b7097b1d295f98034f4d75ffddf4fc706a5f1c3c5cf6b"
  end

  def install
    # Work around https://github.com/gen2brain/go-fitz/issues/143
    (buildpath/"go-fitz").install resource("go-fitz")
    (buildpath/"go.work").write <<~GOMOD
      go #{Formula["go"].version.major_minor}
      use .
      replace github.com/gen2brain/go-fitz => ./go-fitz
    GOMOD
    inreplace "go-fitz/fitz_cgo.go", "C.int(len(buf))", "C.size_t(len(buf))"

    ENV["CGO_ENABLED"] = "1" # for go-fitz
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end