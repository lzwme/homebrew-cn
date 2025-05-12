class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.6.4.tar.gz"
  sha256 "f0f7c8afc6f8a15e714323e7e437a15b9e9130953670570359eef13a997d1bdd"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31fabaca7ad3e5ff43938eb6780118c3769f7f8da9b8ff77e9188840aca9c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a345181ec3f97f756b4011ca0a0426a61215d994b2d2ae86330ea5e9840f254a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1ca47df2d8a8b82a014fba811e3275eb00559cbd533cec1577336a7aeaadcc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f978e42fe8dd18c7efb1a170bcbdbfce8768c1e62e96b327f048f80c9c91f29f"
    sha256 cellar: :any_skip_relocation, ventura:       "e7c414a0fb061b803fa709ab7ee8325d1bc25c6cab58b0396b4c7cdef1650a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67692fc93c9bc0e68d0fa2d792574992821c1dcbedf5eae664a470c44e31f531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af820f22d39ec80cd3a27099473eeafad8200fc6a5854f89c4c8040b5ccb943"
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