class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://ghfast.top/https://github.com/russellbanks/Komac/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "c22ef89c9018a35b10de14c953616721864a86f2a6c4c83f4ceb95785cb8635d"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ddfd2f6f77e51cab05ef1d0a59343f7876b2271aba367f5ac3bb7ce47e9c06c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff3c63304b0a4d63931ffd3d97ef4a35dc7bb80b36de1d7f96c68731ddd2552c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db66f8ff8d9eb2b543f2ffa1bb77100cef79a0be8544357e428c5036c573db40"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f4c81523218b2cd40be944ea8ae117fa29a1d4a6dc50728407cb38e7ead8391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8448b2fe798feb6cb2c0787d8eed1db7d5b8fd04b03256556a8673f57484e172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f598bbd10ea65233232ce712a78b0d93a34e989bb70778cceb44a20695089c4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"komac", "complete")
  end

  test do
    resource "testdata" do
      url "https://ghfast.top/https://github.com/russellbanks/Komac/releases/download/v2.13.0/komac-setup-2.13.0-x86_64-pc-windows-msvc.exe"
      sha256 "32c460e6d29903396f92f7b44dee1f9ac57f15d5c882d306e9af19fc7828842c"
    end

    resource("testdata").stage do
      assert_match "DisplayVersion: 2.13.0",
shell_output("#{bin}/komac analyse komac-setup-2.13.0-x86_64-pc-windows-msvc.exe")
    end
  end
end