class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.18.tar.gz"
  sha256 "41bc9334cc99abb92a1879a240268ffb176423cebddd4db39d9f40e932926adb"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4e6a772dde8e0605008060c6877bec3bd322d3d81177b29f3e670397ec5e92e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6d61d0ed857fc7f304b5c7854d653bb2499f06a78bea38e61edcf8dce1b08d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "968a399a31cd3ab520bafead23df29f6d5f417a2f2e9455488420b4ba2a09d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0a535b0797f3c0fd41c840206cd10e9a29a3896965e313b6fedf8fe9e69e916"
    sha256 cellar: :any_skip_relocation, ventura:       "b25db14a5d09aee9317ab718bf41ff9afeaaa47319277e0f398c841a2b3e4e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e510618381f6315e48e67e838f7e091e265d3d103f746e5dfabbf0dafd687415"
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