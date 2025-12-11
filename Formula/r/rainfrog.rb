class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "3ec2612779499e152b137a4a78fcb46b28c22973ee171ca494e3b5ecd8dd4063"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83f329b32a9214339213f8e1f54350db625c215ea0a5ec13cd9327391df2692b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08a1f0034c5014d665596b33eebeb80af5b1c89ead634a565363ff4c1664668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc8efb57d2dab6bf56b8b46182b015517b613160363838ee2752b5bc18c9fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5cae135c75877d16e12ad6a8dfef5e84ca7f494ef5c3fba64ccec7afbf22160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cfc4c9b604ac44194f8857c1d6abe9b1475f3914ba8d3645fa6a7cdaf0f037d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17621b1dcaff65c47378953b18548fae9be32372088f7ec972a120fad6de1d8b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end