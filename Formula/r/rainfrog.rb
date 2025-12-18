class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "ba0c78563e10bb2aad8e4ca2d8ea8b68590fd36c50b784e5f90c9c0a0b0f50d8"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bce15364e1383b6efb81486cd521f85914747bf77b6d02063a45b9d9c0203166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf05ec67f91bc3d7693486242a4f4e7fb2f08db602a39df1cb7f018e5d3f19b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce9e8fb66fff9f2a90b8db4eaefc1c7b390e91faf43452607e02df7de09d2157"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a0b50da0d21b25510accb442a51afb3f92ccaaddb91f03b0eec233c208f017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f32e3b101bcc7327752e6927dae8c4d14042e378f5852104261612f327d5268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45665aa37aca3264e091bb9d6acdf49f143fe95c33517c0e3108a4fe421f497"
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