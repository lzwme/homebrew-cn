class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "bf738c4cdf2c0511f65e848b0802a8fc93a4906e411ead35478c554b1984e812"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_tahoe:   "aa09091a122326489de3d45bce1538f7c7136d648339f704e799420b48992418"
    sha256 arm64_sequoia: "ed23a6894889753a32642f1bdedc8e46c56fed400efa9fa12b8e130f6d92b9fa"
    sha256 arm64_sonoma:  "fbebab896ed0334bfa587beaf0c7d74666d0b61b897cf3590d5310f643f228d7"
    sha256 sonoma:        "5c7ea4ba98d405fbe7b2859da0387de883684471f3fd2aa6a744ca8e73d66efe"
    sha256 arm64_linux:   "67f636382cddad35626d3bdd9c0dca872c8385bb218659990cd14c0a281b038f"
    sha256 x86_64_linux:  "83afd5c79622679e1849532b84e5bfe9d1a834552c73e3bb797233e3c8bdfdc1"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end