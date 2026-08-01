class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://ghfast.top/https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 2
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b24a3e2c9203e42078806f49d7416852d77324f2c8d402937d224a44227a8cac"
    sha256 cellar: :any, arm64_sequoia: "fc95f30c2e5531c72ec2a18a01b6523951a89b15a165d08510dc011cdfd8259d"
    sha256 cellar: :any, arm64_sonoma:  "c2aa468bfb88e32907a1a85b89542576c989ac6d513436b48f4c8a0dbd582fa9"
    sha256 cellar: :any, sonoma:        "9109bcfe7d31350bec0e41c4bdd636af15d4002b6b56c976511228a72d480d43"
    sha256 cellar: :any, arm64_linux:   "a80a3e8213d4bc0a544a9647795b2448dc3172a983a4f12ce2b4679746ebd296"
    sha256 cellar: :any, x86_64_linux:  "6a5638bc4d4cbef83d811a48b7b8392fa74e4e9bc8897e35ffa2ff02bcc63179"
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