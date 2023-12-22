class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.33.1.tar.gz"
  sha256 "e4ccca0cc7eaeb14bf3a542d3ecf451ee507263e3c8b75c6354bde384522f8f8"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ad0bd2c00ae797c0cb9d678c62ca699300cb61bd5fc14406f8db4f52e263815"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd83994b93260ba2fffbe05e73791a2cf6c98d2b4afe52b3974f5bd1ce7cfa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91049393d9d612ef49752dd4508efda41031266d0de1585304497c4ce4765a9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1aac96bad5c688c42be36dc3d8c75ccd172a369ebd5c219c567f92a543caea8f"
    sha256 cellar: :any_skip_relocation, ventura:        "20d086db5b01c83f433cece6f4e380b42c64c5c8242b039b02b448a2307a732b"
    sha256 cellar: :any_skip_relocation, monterey:       "9d31482818cb3385366f2f93a710ca65c79bea2e208a7d4364738d6d33f8cdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4171538a8962df5eaf7eaa0b543b3890830fa363b0b29db0be813bb4138a9e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end