class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:docs.ignite.com"
  url "https:github.comignitecliarchiverefstagsv29.0.0.tar.gz"
  sha256 "916549104c30ac4b68dd02112d4148c2278eef621801cbd636b94e3be7954b41"
  license "Apache-2.0"
  head "https:github.comignitecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e20db18a20c43645c0f9a5281c3e74cc1431e78c717eba100de0c945f6a1cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff2ebaadbae1fdfc6561a012a05d17d42737997efaa2f98418371246adeda42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b225e92c033e0e7b61752241b55c53536c64706d0e33da0e9f0c6b4cc246431"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbc4f07d470ac2b67849e09ff034463b19effd7c90c7ea2abbde8f7046efe14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789c03a9990d80f19ac82085514ce332a4e034ecdf64e430dda5c5e74c878bda"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    sleep 2
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath"marsgo.mod"
  end
end