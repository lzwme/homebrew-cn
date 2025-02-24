class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.3.3.tar.gz"
  sha256 "378edb90cfad421f56a354728d186b46a2246aebe1b07917319d8df5e5045f64"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c235ca6af94757a8bd72d902ca2d9ee4fc367f0c1ca46eef1045f5326e97853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92720262af79fb4d6307807f9f642e994e4bf19ab9bc6b738c650188bec91ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84bdc7c4a43b85f235a97d02721bd6749c2222e449abc0632204b60a85f50506"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2cb68c459415177019116f3a842e89bccc9b37c78b8adf2f9beaaacee7266f9"
    sha256 cellar: :any_skip_relocation, ventura:       "3ad8af133284de647a951342ca225aef401d293919b9205ea32b5a375d0c18cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c52dc82928a1f0f949abc4b6689e1141f65013b35dc72d07f756d6c6d58e415"
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