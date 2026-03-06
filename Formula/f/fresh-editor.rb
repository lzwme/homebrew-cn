class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "ce83badda8f7b9705f2de45eba2ffb669982617a157f7f18ab2b035c012f67e2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdad47b7d4ddc18d699637dcf238827942926632fa1932deb7ed418c014ee7dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6260fcc72f8a84ddf6fc98e9e66b496bd021c43c1d1313b10030eae564434f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28ac66bcef90f937789991b278606caf01d69a89002284122a799b7ff894931"
    sha256 cellar: :any_skip_relocation, sonoma:        "4103393fad6cbed502ee7ff67e6a1c51a2e354e7cb94aa62441b7dfa90386396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "112d8ee21960d7981b1681553faf3dba1606532ebe2f52814dc08ed12f6c69ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225b634bf182d9c2af4738348788b3e70d8b38a5ad5f240da9465360fba4f36a"
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