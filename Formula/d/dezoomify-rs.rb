class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https:github.comlovasoadezoomify-rs"
  url "https:github.comlovasoadezoomify-rsarchiverefstagsv2.12.5.tar.gz"
  sha256 "aa3e34c257c6f4bda6afb485a9f787e8d99664fce0f8a87303d77f4cc7dd3c72"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a166c70ef80e1e2424fe077b80a9fbe4a9bee71414765b0985675647a2f6a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a87f1ed82055073136d92cf241ca2c927bfd6342e0ca0ef0c5be1b8dcffedf8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1f5a790d2f4450c3ca2d1f727eba238f43e661c71fe413541c0a0082d8dd359"
    sha256 cellar: :any_skip_relocation, sonoma:        "643e17c2e549b671bbb15d36ed9b20aeb6a32e32dd87ca1f8cd2824dcd86eb86"
    sha256 cellar: :any_skip_relocation, ventura:       "a2a11962cca1a68ac66a6a349b06a01dc787c9faa113775eca345af150e1bd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d38435fa39db5a7bace994236bd6d94c1aacb4c8f515b814accc2813d186a81"
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