class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "7c52ec24536b3703b3db9d201601c2ee807156a3f68713b790bb6f55290d2811"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b0c3a8b21fe24a03c575d61f444cefab1bd33d0911cd642e1c764070c6080ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9ef896ea7f1fa3f715c1a3dba68267e7d09e8df9befafd998d5589293768c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4420229f7e0ec15e0fc4de80a62c67c0e19be368760907692019a468a8cce2"
    sha256 cellar: :any_skip_relocation, sonoma:        "296a56a92adbc4c14bf9131462c7897235047e9477b60ac6fe8eed9373970920"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7271f2c02525e7331c952d8f74f0404b8d73d643ec0fc2e844904d8434ef70b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268a52bec54fea8951ffab4a5c0283eea73e7bd0731ae90b0799ffff7dbf9698"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end