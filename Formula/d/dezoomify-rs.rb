class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https:github.comlovasoadezoomify-rs"
  url "https:github.comlovasoadezoomify-rsarchiverefstagsv2.14.0.tar.gz"
  sha256 "8b8b7bc2123a14bfd0ead7657f2bfebfe112a33c8ed127ac6fed450dcda525a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "747be9819d67ad5fbe81b7a583cdc1e42c117cd5038bc6cab44980efd707c4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e017ca0e79ace888ff12e6ddc3546afff5d886e680edcff50c9d34ef1e22dfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc135b2a06103c45d8d89c45c147fddbf2e0a8dfa55aef72ed9bd5c9c0138923"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c45e11b3f3a42733fd51e643c4ceaa3edc6a5710e3da21da7bc6ad589a2af96"
    sha256 cellar: :any_skip_relocation, ventura:       "5a0f8a4093c54f35c216f3a7be56f750c09fd559902ae3c8657dc4f16fbde608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00f2a647ca94a7be398fa0dba17ac1dce9a9bbfdac257760387b4e942e499a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36e7c6f0db47cd0d0b12ea6310e6c098607e8caf4b85464e914427d584070799"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"tiles.yaml").write <<~YAML
      url_template: "https:cdn.jsdelivr.netghlovasoadezoomify-rs@v2.11.2testdatagenericmap_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    YAML
    (testpath"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}dezoomify-rs tiles.yaml 2> devnull")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end