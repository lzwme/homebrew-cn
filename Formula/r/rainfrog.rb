class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https:github.comachristmascarlrainfrog"
  url "https:github.comachristmascarlrainfrogarchiverefstagsv0.2.16.tar.gz"
  sha256 "3bdcca185c4e0dada876e4e6b9ed0b81a6f6ed2d83b5d4167c6f32a093123efa"
  license "MIT"
  head "https:github.comachristmascarlrainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e758d90cab8aa9fa886007c19a5f2323471d103d31b1e7a6fb70c5352e407b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7613d42dd29bed4e056b288b15625556e9a24f91f3ceff9785b863719a30e43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd1e51ef4ccd426b1923e10dfc9c6a394e4f86ca34f10460d7e2ab13dbc25702"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61cf3b01a8d212d98061e5c1a80cfc8ee87495470962c8f0d97bc2ca2f5b303"
    sha256 cellar: :any_skip_relocation, ventura:       "7927ff96058d600066862feeedb4bd992befabcb7892439530b4282db932064a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f6b043dcaed12d8ba7de72824199449bb8e6cd99b3d1921913f7b5cffdadc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2bfd705f4332bdb1f2061cc86a6ebd0dff00e74d24e998898c64a1becf58433"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}rainfrog --version")
  end
end