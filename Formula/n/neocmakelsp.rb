class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.20.tar.gz"
  sha256 "2cc1fd14120e634474c3e357d5f73dfe2fc6ba8bb088145ef0f546ffc852552b"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219ae89162d1d5fbca158b79774b12733e56fb88fff2ed7f698b8491a9beaf6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a62b2ca1ba2defc5218f274d411fd46e04ce2e5d276eea4021a21ef01d90c04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f822bcd7886c33bbeb1db0a16689eea56f7a5106de1f20bd7bdeba3e7d63add4"
    sha256 cellar: :any_skip_relocation, sonoma:        "337a533859ce3b82531f5f14effb7dd611f545609fd61541e49ec06ee4129193"
    sha256 cellar: :any_skip_relocation, ventura:       "dc789d7ded3da56fa2745c384bf36aa405c8144328aa25ab15d50b1d34c6c952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2a6f03c508250edbf8a6c707533503b6adb13c21b5842bae99c54459b1819e"
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