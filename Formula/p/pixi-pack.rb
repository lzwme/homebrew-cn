class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.3.2.tar.gz"
  sha256 "52c15d74879c5593f52e9b6c3db19dacb2a9a127bd9f247c2282fe1d21d70ca0"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28dc271695cfc038a4e082f2df0b0d73612f0dae8df0d2e5d5c9b91d04921741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306cd31ee6d09c61a2d2e8fb0ce5b7a6146d4d8f911f895518cf810fbc50c4c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c21a947dfc2cdceb210c93dc8b123996e01b61122a1f7ea8821bab0ac12ce644"
    sha256 cellar: :any_skip_relocation, sonoma:        "e54b820cae5a8ce2b38248ffdbe2e41250086d981ad6a0a6f1c95209e5396b36"
    sha256 cellar: :any_skip_relocation, ventura:       "e03575675a2287ea01398038f049ff2069736256ae3351e51a75478bb18330b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c19b49f0ffe4ce2a84b05955ec53ce0763acf0343cb9d2fe8e565144028057"
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