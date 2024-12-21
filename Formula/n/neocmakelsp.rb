class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https:neocmakelsp.github.io"
  url "https:github.comneocmakelspneocmakelsparchiverefstagsv0.8.14.tar.gz"
  sha256 "b20ab4aead9cfd8b0da40bc5a3ff449dd26a005c771aceb6e5468808321b7bc1"
  license "MIT"
  head "https:github.comneocmakelspneocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac98e2a81bfe2c3bf46d00aedd971edc90760e9e82d227d5f3c268326803f205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88ca3e36a14ce97234c2d300432798e0a11334d015d128ff59dca8c459651a1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e126e8d84cfe6f75f12150021c138023ee10093c7be986baff3f1897e28761a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5252fa07301133b79715e30901bc35714c12f59e7e16e19adba6e88c3c3e1067"
    sha256 cellar: :any_skip_relocation, ventura:       "4406eeb8b120839483fa17b35d344635396d64c0181227b7a791618521b5984e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e7c8003c3dbf43d5796916da74e49cd182818f0a2d20010fd44e4a2a5cf283"
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