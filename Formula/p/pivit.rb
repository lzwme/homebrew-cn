class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https:github.comcashapppivit"
  url "https:github.comcashapppivitarchiverefstagsv0.8.0.tar.gz"
  sha256 "c53c6ab0e6b8842ce763e73483766bece1bb107559cdd853f7fff97415309738"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d4f84b13a61cb82ad17efe9b2549d8e5c3f4170b2dcae6ec6b40d428e417633"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d12fbb425136b64fb2d0db00d3822565bf8a0226a922f63a552ac958487851f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c627bcefcfd0d95e9e70bd888eb45f7a41cf29fc6e440a5008e08f3ea891b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "95ef9424a56a71ae028bc241075e608a279181cc41fd938ce59e3a373008b067"
    sha256 cellar: :any_skip_relocation, ventura:        "5d146d29fa140fad8637ef8fc71efaa7dcf1ca9468b14eb5e3834bf1e0d6208d"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a8b021d9d5511e4bfcea291856586dec23f5336a5bac7d97d831386d19e123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104989b7a68db8bb23b305155b2ee76b6d58d95001a221d49cd0265ab825a28c"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args, ".cmdpivit"
  end

  test do
    output = shell_output("#{bin}pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end