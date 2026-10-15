class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://ghfast.top/https://github.com/russellbanks/Komac/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "b87a4cec1c2dc8a334812d240c668692ab463f81ca58dc210b95f599f148b183"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "133f49198854a51380f4c17f320adf081ff2476ae6955fb54a648b72aaf3df3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62e9d5dd0341f6d9435013a0f50ed608c0d502160730d8335ab8ee3f561907aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab4ce57db700bc451c1944c490ca588afcd05bda343b5737a32db2a7d04b02e1"
    sha256 cellar: :any,                 arm64_linux:       "bc072c0f77c1f4aec340ebd43acdc1817c3b9b59d2f12418ace4697cbc62e0a4"
    sha256 cellar: :any,                 x86_64_linux:      "6e37334ccb91dd46f5043ccca54429e7345fe2d3b0ca69393adfc266198898f7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  resource "testdata", :test do
    url "https://ghfast.top/https://github.com/russellbanks/Komac/releases/download/v2.13.0/komac-setup-2.13.0-x86_64-pc-windows-msvc.exe"
    sha256 "32c460e6d29903396f92f7b44dee1f9ac57f15d5c882d306e9af19fc7828842c"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"komac", "complete")
  end

  test do
    resource("testdata").stage(testpath)
    output = shell_output("#{bin}/komac analyse komac-setup-2.13.0-x86_64-pc-windows-msvc.exe")
    assert_match "DisplayVersion: 2.13.0", output
  end
end