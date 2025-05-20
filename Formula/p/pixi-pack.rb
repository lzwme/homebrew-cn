class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.6.5.tar.gz"
  sha256 "6ca87106a44632c49394c42fb34b5f78f393bfd66b959787263c7730d7eea598"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fbe7848aef9ebe3a142f983908b7e82f05172847df19c3cee3506f6c194aa8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "524ec39aed29d9b9790a5869184376d8459d99eec876bb9710185745fc985238"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f492ffa6ee54a9d2c16571367e98f5ae97b146995d07c38d55db263f81c08309"
    sha256 cellar: :any_skip_relocation, sonoma:        "8da1861b3a8bbf528736a3a4f435d04fe205b2bca0d30921b4bf01d0cd8352fd"
    sha256 cellar: :any_skip_relocation, ventura:       "94bbf93e3a4e61133dd9ab979c148502f7287378b35067f62e80bd72290089d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06a6694dc45236f3f63d1a02b09cd9357c277f00570818b987b051e531970232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca9ec0f80beec0f4136ca58fac866089c7359d4023853a9e5a17a263520929da"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi-pack", "completion", "-s")
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}pixi-pack --version").strip

    (testpath"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https:conda.anaconda.orgconda-forge
          packages:
            linux-64:
            - conda: https:conda.anaconda.orgconda-forgelinux-64ca-certificates-2024.8.30-hbcca054_0.conda
      packages:
      - conda: https:conda.anaconda.orgconda-forgelinux-64ca-certificates-2024.8.30-hbcca054_0.conda
        sha256: afee721baa6d988e27fef1832f68d6f32ac8cc99cdf6015732224c2841a09cea
        md5: c27d1c142233b5bc9ca570c6e2e0c244
        arch: x86_64
        platform: linux
        license: ISC
        size: 159003
        timestamp: 1725018903918
    YAML

    (testpath"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin"pixi-pack", "pack", "--platform", "linux-64"
    assert_path_exists testpath"environment.tar"
  end
end