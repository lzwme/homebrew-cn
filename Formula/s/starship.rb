class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://ghfast.top/https://github.com/starship/starship/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "3d98e2c57dcfea36c6035e2ad812f91cfe33099e4b67f6ea7728e2294f02ca61"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67470b986c8aacf4c51507a4e0569e798ecd65f4e388b156e19137fbad731984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22a3a0bf85b03ce4ea3d0dfb0b5092207030961de953c6ceb7c3c602bf4a6b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce39c6c77f8e0534ff10c3d9a9277c7f3baf1dbb30212ca28d6321c8fcce023"
    sha256 cellar: :any_skip_relocation, sonoma:        "d793b8be85ab1f7525c4be58ea6780f189fde43e7d01fa15d5cc64d0cef75b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f21f8d57cb70137646ef6b60ea8196fd65af633ce4627d735bd36b945016e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3e2a5b9d2048c2abd360480af478b619a7e85a43200fd04572b2a58053418b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end