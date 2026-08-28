class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://dezoomify-rs.ophir.dev"
  url "https://ghfast.top/https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "f19cf1560adcf398abbe6a5b9cbfc4734caf9a1b9b220c871848097e8d7104b0"
  license "GPL-3.0-only"
  head "https://github.com/lovasoa/dezoomify-rs.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7a1f8e01226c39e70c0167470fb827943c89eca2e6fcd517b79bf5b77e64d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d903806f2b75a343b369ee0b575db9ec04a0ba0a6532c094599246ba51a6c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74d1d815d065749be5d4dc1186fecc9f53074ab9aa0724f6edab2d36b95b99fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc0bb9bda80b0bd63c9103f6d7ee3b2dd0dd1957779ad4afe8b6008610c53a25"
    sha256 cellar: :any,                 arm64_linux:   "c5517b2b1dbaefec0ba54ccd3274ca2be310f36cba8a27d58ba1f7a86d967a5e"
    sha256 cellar: :any,                 x86_64_linux:  "8f949fc467d4f23d1c01646d9c4b4831bec3a77e6cc40b36b42ef072300ea2fc"
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
    (testpath/"tiles.yaml").write <<~YAML
      url_template: "https://cdn.jsdelivr.net/gh/lovasoa/dezoomify-rs@v2.11.2/testdata/generic/map_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    YAML
    (testpath/"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml testtile.png 2>&1")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end