class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.19.tar.gz"
  sha256 "e63cf9a59f818c61196ae41136c164d62fe1fe42116c7dd51bee0f9df2ce55ac"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e92cdea6c96034023defe7e555b126f537f0ea540344851547e6c1bb3033d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d32242bf79b08f4b658aa843fc41d12a36f13790cbac07a698851e8b26ba1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46b8b31a5646929b7ec0bac822a11157c1cb1ebfde6bf86c25c40bd7a21a8b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "122c5746484cb8c60d9facda43367d5402127827d3ddbb4e065711ef62b9f4b9"
    sha256 cellar: :any_skip_relocation, ventura:       "3aa31f635e6b08f4efada54b8845d0ab9ed9de32cd8c7d9a0f191bf1bd06d684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e149a818be9bfd21fb6cbb0b68f336f05a92534016e30f184fa5d42cc41926"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.cmake").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(TestProject)
    CMAKE

    system bin"neocmakelsp", "format", testpath"test.cmake"
    system bin"neocmakelsp", "tree", testpath"test.cmake"

    version_output = shell_output("#{bin}neocmakelsp --version")
    assert_match version.major_minor_patch.to_s, version_output
  end
end