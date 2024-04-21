class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https:github.comlovasoadezoomify-rs"
  url "https:github.comlovasoadezoomify-rsarchiverefstagsv2.12.2.tar.gz"
  sha256 "f5ec763a8165b887f7ab14eeae955ce103fa0b05bce2df8a4e5a148f14816e29"
  license "GPL-3.0-only"
  head "https:github.comlovasoadezoomify-rs.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bde9b3b68e35fd194f0861b097b3b81588bd87d9670a387bf6133a294b72e0ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292efbcf309f89710c852a64a4002325d67acc66d02b72d8b73a8771ca028a58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0866061ef16851f5b07bf404641171bfa19101ec0222989324b29207eeb35843"
    sha256 cellar: :any_skip_relocation, sonoma:         "41f5bafa0b2f123c3820eaeb91eb5daca5a67478cce5208cb3a9b027ecfee82c"
    sha256 cellar: :any_skip_relocation, ventura:        "7f91d3215e33647da6c9257f0cd5259c188d0bb6c25ecdd32ab6c026de8cae21"
    sha256 cellar: :any_skip_relocation, monterey:       "7503e41453e42d4b4f7a27a62e379841f97993d4cd7ca114f06f7a179da356cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb216f97b949b2223f7480a952ca14ffa95ab7e1ceb3edfa6df018c7ed39ab5"
  end

  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"tiles.yaml").write <<~EOS
      url_template: "https:cdn.jsdelivr.netghlovasoadezoomify-rs@v2.11.2testdatagenericmap_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    EOS
    (testpath"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}dezoomify-rs tiles.yaml 2> devnull")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end