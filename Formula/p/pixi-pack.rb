class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.6.1.tar.gz"
  sha256 "6ced048be157eda84a45cc6e49c0aa5b13cad3dc7d34857bb0b494a5384ce9f5"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc13ccc8479f2fed92478346272f5ee2e4ded6ec180c062237714ffc43920325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e7f273d9a7bb8a8a5dcfceda50b771a36b5f04647cfe3e4200729100af2fcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b207f79f866aefaef80d10a6a47db975c30e00c23c9531d1990d49b479c50ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c3cbc15ac07d4fc960a28072d472d7a794d9f25814adc32970d57ab81bd997"
    sha256 cellar: :any_skip_relocation, ventura:       "61b50007e0656ba0825a7d5b532a96b4e04c3cf644bd56537b898adb764c5387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aca55a94aa79e33b7a2035c1f887aab6469f65b6092c5b046784befca7623fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7bd0b15384599e0801bf51ba46743b65cdb72c0147908406ee19c0abfabb5d"
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