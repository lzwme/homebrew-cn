class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.11.2.tar.gz"
  sha256 "cafea69fdf28d6223f68ce7a6f8e88025ac7a330cd96eca97fa6180df483d5c4"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f0e20f5a2312e6d6291495d85fd297cc083699126e987e6343743b36ee9f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445ac4d612a5cfb2343834d91213deb5c04c7b0915a93e11fb24e3a9137456e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3263197031d83f6266dad6b6979abf87e7fdec97216a9a4d05acefe566818f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d999e6d0d0dc18767c4a897b8e44456ec26e9e0e00a76ce8c582a1cfcfe090"
    sha256 cellar: :any_skip_relocation, ventura:       "d5717e593806e45b491613727f65fa0de2ffcc6c762a04f98edc38e49bbb2eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9cf4ee3270550502b7f1091b53d9dbcef1687ba84dbcfea2824e7c51c597038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1751fbdf2c605e38d87bc464d86f22855ee805919f394aa9d7f5b08c9e2bd62"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end