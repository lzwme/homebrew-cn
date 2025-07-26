class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://ghfast.top/https://github.com/rrwick/Autocycler/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "c4331f562f993351c60156f16479e36e6c013f5fd1bb51fc0d34682364b59d7a"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ec87e0607bcf0cffa5c45386b5455dbad79bb8e459089860ecd5becf5f71e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1888a812c8f459042ab92b8c3767267b6f5bbbfe34aac1ab8a1e3d9b3962c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31bb2857801eb68298f6cb58376a82a0063021a97bd4a293c3d9b45a9bb1c7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4a05ad72f762d8ec7b5713e5903473b12ab1cdb6fc2fdda8639532d5d094e2"
    sha256 cellar: :any_skip_relocation, ventura:       "53a28356c941ebe875e12cacf247081a37860de6d3c85283ddf082e6a0f536ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5451e8a1c7fe21456c736978a966a17eb5c9bf3cc75a05702a3b2b676b1f28aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619f9c66ca84fb0cb2d5193d019c96e07ba2e5254f49477b38903a42e1dbb880"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "autocycler-demo-dataset" do
      url "https://ghfast.top/https://github.com/rrwick/Autocycler/releases/download/v0.1.0/autocycler-demo-dataset.tar"
      sha256 "70a5480b4390b2629a9406aad788cb2813570827b86b37b982609e6842ba0bc9"
    end

    resource("autocycler-demo-dataset").stage testpath
    system bin/"autocycler", "subsample", "--reads", "reads.fastq.gz",
                             "--out_dir", "subsampled_reads",
                             "--genome_size", "242000"
    assert_path_exists "subsampled_reads"
  end
end