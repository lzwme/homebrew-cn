class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "08bc618b56a7eaf8b852303bd4cc7efe1f084a21a8c6667d67e963f84c2c6fce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277c8cd4b0a9521b8b3e128504130fe7a6a20beef8d30e596883adfbb0f7a557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed7ed883806d774aa1abf9b6e5a85a63babdc820cf9e0449472e05015295f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e299cd1ed43c4d2cdadf9b51533f9739159947382b3099868a877f932dda344"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32f418373874694c4a358f8914d2b3f0c035929eabff893d0725c4e9ec9db5a"
    sha256 cellar: :any_skip_relocation, ventura:       "c3e50ea7e871325e26fc1dcee7a36b0474d0c5d51eb71e8de9e2aa4e1f9ca849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4899e7bf70de13015c2bf1351a84f7d99378f223e64a64c35dd69272f55a2114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0c431ad0e0bdd2e223231583450bf89b5d5f0b4f9cdae16cf72c1ab61e7b2f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end