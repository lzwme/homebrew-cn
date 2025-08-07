class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://ghfast.top/https://github.com/alexhallam/tv/archive/refs/tags/1.6.0.tar.gz"
  sha256 "512c0019879e4be16a991a4ff34f5791cafb0748fd9bb0b25410a97ec5e32950"
  license "Unlicense"

  # Some tagged versions using a stable version format are marked as
  # "pre-release" on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d82e5cc45baedd7afe35c69676c3f8b1ea9bae6f977bf87bce374ce5597e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7c46d388575a20bc9667c5b1381949a25b09a0aac53e655cac94b6df795ade7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f608046ca42e03bb2b0d3e29ca3f1862b9e0e2284a9f987895992e515dc8978f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e8f12209edd4db6ed5526be537292f7b72a4827d5a86d8a7f4e90fb0da6d4a"
    sha256 cellar: :any_skip_relocation, ventura:       "a1ab9b675e65c10e78e387438733daf401f52d4c64a1ce0d6ff9c8cdcd812d07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0e44c38b4b5e2f497195906baa10925984d0765ccf0123976760e38825b788f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db2def44e6deb865b75a889bfcd14a20fad94644c6c45e13142d0981ee4da0db"
  end

  depends_on "rust" => :build

  conflicts_with "television", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end