class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https:github.comlovasoadezoomify-rs"
  url "https:github.comlovasoadezoomify-rsarchiverefstagsv2.12.1.tar.gz"
  sha256 "fa46f7417b373dfe60e452f0c4532e3a046913fbd4e3fa20766308911b9d30b6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b98b7f8deac220076335e31ca4102d20d2d5caff8c59066ed69b5b15fa2a972"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e72e876b0f6aabc81f7e35a3ecb3c12d08a328b7ca2d6da0adebf5bfa5201740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd9f898757cbe944d1bf92595f4dd21510d8111b08c795124a5047b6764002eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "867474ccfa0372602e2e94bcdd77b8935fb72c95831b9bb13850b015e8743b9c"
    sha256 cellar: :any_skip_relocation, ventura:        "f68d0f11b53560aa3c432e9b0ae82f7662fa7e7306e74921408ebf112bcf6c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "bfaa029870bf039ec9868dc2962acb37899fee427753d061d3bca18a9924e347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee848d3a1fd96bb1196d3bf710c733fd7b5969e1e3a2b99a3ef1a63655067268"
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