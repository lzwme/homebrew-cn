class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://ghfast.top/https://github.com/rrwick/Autocycler/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "8daa6f3a5e6cb74ab64e484ec49314a84577bcd469508d36d1d6cc8cfcb5687f"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "234f892dbd736451423a7f231fbe50c9dba62ea1f8d4d3ba24f2e9abd4f49fe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d90a36f630e12e96d6eb672d8e80f0d2e9cde1d41c73db75e529bed5cf87f2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dc91872538e599731434a37c7d8d8f80b2f4f842d698af87de2c93a342e5320"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cc591914240e00439cf1595c175e606f8423c058d5cb970ca82d09cdb89c60e"
    sha256 cellar: :any,                 arm64_linux:   "c1f63f8af82e524801ca200897345afc0c173cc5f83a2a9039ed1f549160c8a5"
    sha256 cellar: :any,                 x86_64_linux:  "adf15fda7e95e64498e56b2e48483a4cc033415959d60d38fc8ccaafd1cb686f"
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