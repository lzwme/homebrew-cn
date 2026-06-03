class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://ghfast.top/https://github.com/medialab/xan/archive/refs/tags/0.58.0.tar.gz"
  sha256 "434df1465d2752b932efc8556d4ffce1ac0db5303b45ccbb86d87ae591447550"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ac017ed3c25361db6c5a995c5e01f5365655f4efdbf18428c66647e8ff48bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed21c82dd4aba4d564300e67e5612c92f6bdd0a6d1eb91cc6928ef4779faf542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5e8ccc2bafa52ea64e1bb034791ddf4d1fefc18525b9eac28d88266bf65c44"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c6927b7edcf30bb88bd03c3d44fe3cbd6fccc261b337bcfd551e066cc466e5e"
    sha256 cellar: :any,                 arm64_linux:   "cffe2007c9a30aad0d3cebb29efa8de3ab19dd07202a4110c6da2347b75300f7"
    sha256 cellar: :any,                 x86_64_linux:  "40a5c6adcf7acc3586ae8308550e0893a0ad81fe687d38a8fe6a30dc9f7c4f7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: "parquet")
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end