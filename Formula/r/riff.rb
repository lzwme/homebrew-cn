class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.2.tar.gz"
  sha256 "3d0d67c7ee28e33267994c03d8a5641c7e085088e126bd655fbc0d195d986738"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384bcd0d227035706cb0817b62325adfb40cf40200e862bf379294fbdbf8dc18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe3e40391f5903ebaa4267cdb2bd420eea4094007e177c822a650e61f7afe35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2c6896874070cd8de17e0bb387733936a4ab297393dec38638516825f33ac3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0240edb419475df17f74fa002a01dd5406806be06c9c81a9fc843391bd0f4f0f"
    sha256 cellar: :any_skip_relocation, ventura:       "2dd78ccee6dbf20a681fb4b57271c85f5dede0aaf73f73bce7fde2ae185c6fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368213d445ad3722ebd02570c3a587e56cecfa232a3a5acfe181e170a57ba0b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end