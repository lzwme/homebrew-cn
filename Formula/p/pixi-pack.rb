class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://ghfast.top/https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "28421eda4187559b3c2934b16d15818b840d69fc7588172cbc0ad98530d6dca7"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c6ff535614b36633b166468dd36aae9d54a865f77f8c4189bcf9fd4a79a9eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb857ea3c8bd6806c7c9c1040d8bfc52bebc42ddd83a9812374d4236aa68f55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f396d176103d65875d50637614b0ea5aceae8aab2197df67460917fab1beee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "abcf383d9bcb5a49f71d324249f300fad175b5d4e002b73dcbf54617b2749653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b70d5a662eda3ac7d58be5758615520b20145fcb9cad9568bc59ff414cd2a7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7ab4bb3f8e164142792260427c50448d92189802fb02a068cf2b77b6793b36"
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

    generate_completions_from_executable(bin/"pixi-pack", "completion", "-s")
    generate_completions_from_executable(bin/"pixi-unpack", "completion", "-s")
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}/pixi-pack --version").strip
    assert_equal "pixi-unpack #{version}", shell_output("#{bin}/pixi-unpack --version").strip

    (testpath/"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https://conda.anaconda.org/conda-forge/
          packages:
            linux-64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            linux-aarch64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-arm64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
      packages:
      - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
        sha256: 7cfec9804c84844ea544d98bda1d9121672b66ff7149141b8415ca42dfcd44f6
        md5: 72525f07d72806e3b639ad4504c30ce5
        depends:
        - __unix
        license: ISC
        size: 151069
        timestamp: 1749990087500
    YAML

    (testpath/"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin/"pixi-pack"
    assert_path_exists testpath/"environment.tar"
    system bin/"pixi-unpack", "environment.tar"
    assert_path_exists testpath/"env"
    assert_path_exists testpath/"activate.sh"
  end
end