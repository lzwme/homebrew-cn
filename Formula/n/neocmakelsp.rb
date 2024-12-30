class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.15.tar.gz"
  sha256 "355b7bc05c0ee44e12e4827e1d4d43ba7d1009802f5ff7aab8f681e20717278c"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7451f1faf4120feecfa522e289c2f89f282fbe318c5ddbac33931c1b28510cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef2afece125aa3d53208a4f2595e60d45e94f1e6aecd7caf62b42f02d32ee5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec2e9049d52e7bd712daa804231a8346d2dc8a96f6f86576219beaa99279a607"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c9987a79c935e5cb50e1256253b6a701fc830efc7a7ca6033670a03086c6780"
    sha256 cellar: :any_skip_relocation, ventura:       "1e91c73cf9342923fbaafe281cc72a9d1db8699c09a5a2c1c892c352fbfdd2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb8c66ef1dda336f3acc761d5bd35dfebf698c4343fb80b1ebdf4e114a381af7"
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