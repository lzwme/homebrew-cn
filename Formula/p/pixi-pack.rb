class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.7.1.tar.gz"
  sha256 "02c9f66d35061ddfbd690a632aafe4415d451762b1e755010a8b33b81285f686"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "834c04062ce32eb7f89a6ca6b121822d56e32b7871434cec05e8116ab2b3cae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e07c3d3dc051a6b8b9d63c0e88c5d8b962f94e8501d613158d00874e9d1d27d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bb22dd8ec26a6582060a5f093d2d7a0da6c0d502ce25997bd49f1157a1c615a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b366f202b2bdd99b5cb62b6bc931cfd5294ea37d2968f05c8860dc5a0f8633"
    sha256 cellar: :any_skip_relocation, ventura:       "90e1dd960cacc3786283d3b79ed381b4732e45e741583d73e1b35267c13658b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a557cadf6884cac72e30c5c5353c9aba5b79ad1e76c52d319f7ed9e6afe33ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c500859e059e015e4ea23e07a33eaf88badbb3df79cf23f44c70d9e9eb19a6c9"
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
    generate_completions_from_executable(bin"pixi-unpack", "completion", "-s")
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}pixi-pack --version").strip
    assert_equal "pixi-unpack #{version}", shell_output("#{bin}pixi-unpack --version").strip

    (testpath"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https:conda.anaconda.orgconda-forge
          packages:
            linux-64:
            - conda: https:conda.anaconda.orgconda-forgenoarchca-certificates-2025.6.15-hbd8a1cb_0.conda
            linux-aarch64:
            - conda: https:conda.anaconda.orgconda-forgenoarchca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-64:
            - conda: https:conda.anaconda.orgconda-forgenoarchca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-arm64:
            - conda: https:conda.anaconda.orgconda-forgenoarchca-certificates-2025.6.15-hbd8a1cb_0.conda
      packages:
      - conda: https:conda.anaconda.orgconda-forgenoarchca-certificates-2025.6.15-hbd8a1cb_0.conda
        sha256: 7cfec9804c84844ea544d98bda1d9121672b66ff7149141b8415ca42dfcd44f6
        md5: 72525f07d72806e3b639ad4504c30ce5
        depends:
        - __unix
        license: ISC
        size: 151069
        timestamp: 1749990087500
    YAML

    (testpath"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin"pixi-pack"
    assert_path_exists testpath"environment.tar"
    system bin"pixi-unpack", "environment.tar"
    assert_path_exists testpath"env"
    assert_path_exists testpath"activate.sh"
  end
end