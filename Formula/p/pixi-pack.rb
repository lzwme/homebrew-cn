class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.6.3.tar.gz"
  sha256 "4f15c9f2e7774e2a35f7af383096f57d757f06ed09ee4f0390dbabb3c51167e6"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf82a94827ce2e30869196e6ff1dbd2599b84047ef03abb11538da3e6f35ca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bedce2a0e5bf122eda97d7179ce19789bd6f1b8a8d22a310f51e01c61535d6c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c88bd57431b3e58ad24df5b2e15b07dce3da244c026b97f01d0a945a1176671c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4377ce4d994420cfba8150b89143026388642fddb5c061f7a50b74c6b722ee79"
    sha256 cellar: :any_skip_relocation, ventura:       "9e92c8ac3a054e1eff7589af48114ceaad48ea27b628236e29b137dd1ecf1b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6908500382eb71c055d9bfe470809877ad2c88e4b8b918448df8c80d95c0529f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db4add9ea67aa8017f1b1ebfa5619892c49c1b2e0de8e0e13e7e9b9294fb785"
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