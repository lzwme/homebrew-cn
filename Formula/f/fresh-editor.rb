class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e02d81804b25c5648b87e0a4bd65faf58b104e8ddb96ce33740107c4edbfc155"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9a2e2d47ece89fbbeef9df5eddaddce899642bad46aa83a6d2f6aed8efb75f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec59e542e1f2e74939c888725f4aa31d9eeb13ef9f5b3b83aeec0d9ed0eb242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d375efb1d9eefab8a522e83ebae23c3b788e659f294463bd78b01f20fac74d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "bec4ab0bd4c62a3e35023c27ded91c24f607781e7296a43423dcebe39ad21312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f9a6791192107d0302931bdd73e5660cb335a2493086b93442ded6466f0514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933cdaa128ff83b9287d461c90c6d756a2348e537721b0f63e832d90372ce3d2"
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