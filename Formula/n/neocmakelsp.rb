class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.21.tar.gz"
  sha256 "4651073b51f903d7b3706e404c1bae11e44a2a5a3c71c3ef57c52e155c251cf5"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ea433d16a238e91a015a5200dffd4decafdf44c5d8e2da3c7ce74941d8f449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a478f15033196a03420d96629525564239400024871ff702ee84f78777c34b3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12bd7ae885d91f14a34d9dbe3be7da37f8c956c05978d069c45478b79cc2049b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae623a04f44e50780dd0739f7090e786819d1cf8a34a4950901349fe377bc23"
    sha256 cellar: :any_skip_relocation, ventura:       "70814582214eafb1e9c3e806b09e5736329abaf2b2389bb2a89f5b1860d4c997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402c5ab649474e728fa6cfbe0916e1ecd5ef89474ff2f2545dbad103128dd708"
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