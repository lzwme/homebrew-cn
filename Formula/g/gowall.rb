class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://ghfast.top/https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 6
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a5c8e66f67252660ef74a433f206de8797f71aec2f346ba9023457519b2e7084"
    sha256 cellar: :any, arm64_tahoe:       "8a548f86e38c74d3c33f94c0312199e844dcf2b503e3bdda28d44cec2bd686df"
    sha256 cellar: :any, arm64_sequoia:     "0762980e468345798966d0d9be7de36f34cab70b8fa73b8d74f6c4eb8cc035a2"
    sha256 cellar: :any, arm64_linux:       "14fb09905e1a2835b98b7ca8ffcf3f4211700e45bf9823802e4147eae4fd93e5"
    sha256 cellar: :any, x86_64_linux:      "d29ed09867b45e24877a43fbd5b3f25d9f27d381d6590cf99b0fef6dea1151d5"
  end

  depends_on "go" => :build
  depends_on "mupdf"

  resource "go-fitz" do
    url "https://ghfast.top/https://github.com/gen2brain/go-fitz/archive/refs/tags/v1.24.15.tar.gz"
    sha256 "086b656bbb00c314083b7097b1d295f98034f4d75ffddf4fc706a5f1c3c5cf6b"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download", "all"
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

    system "go", "build", *std_go_args(tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end