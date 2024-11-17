class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.12.2.tar.gz"
  sha256 "74f6979fc6e3dd2e5d58cce314eb0e71280b7da2a4874795634a01c01e0fbab2"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a9e7eb6bb99028680ce2a5f5ec7e2d708724332d10892d941b9dc675fac59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87616a243e9163f8d730bc4444f0e38dce97726e727c07ce444f97847d62133e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8fd25c942117c93d35963cb4e92dcfb13bc7776cc524053c100bbbb13596c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e2714b22233dcece1a0f1ed3896d1ec0fde59c28c7c5ab3dea7cba2c5b3855"
    sha256 cellar: :any_skip_relocation, ventura:       "095da8430a3891661bdf352d00eead2975f5edb8e9156771e07a3c6d0a773f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716e6dd35ffb34d39417b424ee4b943a635b08d19d0a4747fee5b2cf8e0f3419"
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