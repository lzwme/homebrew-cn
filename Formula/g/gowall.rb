class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://ghfast.top/https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 4
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d73d189fb610bf5e83d35e9d051ad71b21b7e529794fbc1a187868590fcf970"
    sha256 cellar: :any, arm64_sequoia: "6530f9b977fed481217da0d99fe19b2a935050cc1eaf5221f29c707ddac124c7"
    sha256 cellar: :any, arm64_sonoma:  "2e97d4dba6c2f0fe1de673d7af45943d6e6a93fa20271796d75f5eb94bf6b955"
    sha256 cellar: :any, sonoma:        "585556bca09dfcf68913831a4b72119b31e1037280d10bfe83901347984e8e37"
    sha256 cellar: :any, arm64_linux:   "8cb7ef0fffbb79053742bd46c602c6f98c656a7f49f3c37d525b3b4dfb4a6132"
    sha256 cellar: :any, x86_64_linux:  "f88a655038809d219b842f383c868f29ebeb8fe34cdf872d12894a19fbefda68"
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

    system "go", "build", *std_go_args(tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end