class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "55ff033a3865e108a99a59eee6ea06428c4db3c8e19f1d9605e402c18015e6f5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363d89051f2e7ec103d373f1877ce8efa599754b52f9dba74d4d5e20472c4582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b2bdd2236caa4bff063348f801c9608f647f6a8e1cdbbca75997aa1a572a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f9bc133eb3eac61087b354883e58c70b146e7123682937cc371422a45b4e8b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "945c0f2a5d09cd10ae0a898613d1fb3e4e253227023d2b276cb2e799e9898bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19b3c834f051e8c59f973afb38b93ba5326fea476c8432e3d9a738cf0673ef17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a397b13f64a7f4bcf0e2f71f2e7c2dd30d8d24836a82dfa78286b762e2e0bae7"
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