class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://ghfast.top/https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "b7d3dc76c032ffddf073254fa200c0282476852514845d46e0109bcdb038a145"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca94f8cc93471e97fea3b558096001fcc102488886a15afe86e6df0438c93b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59597286cac016a3f971ad9061b15d736d68dee5a2b47f549d5c88200ab8f47c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb1b5dbeccbf9e229eb9ab400350ddf159497e1027818195c2890acb5af7b3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "64705ad161968c36c43a4f1d5310f6f01501999fb98e1edd42f0ed2f3f9b4c39"
    sha256 cellar: :any,                 arm64_linux:   "a2c34235015aab826866e91842c5bd0dc99d852e89179bfd25580cc25891a788"
    sha256 cellar: :any,                 x86_64_linux:  "e395a6aaa5968dd004af424138ccf8d1d969d2666906bdf64bc6aabd3098a372"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oarfish --version")

    cp_r pkgshare/"test_data/SIRV_isoforms_multi-fasta_170612a.fasta", testpath/"test.fasta"
    system bin/"oarfish", "--reads", "test.fasta", "--annotated", "test.fasta",
                          "--seq-tech", "ont-cdna", "--output", "sample"
    assert_path_exists "sample.quant"
  end
end