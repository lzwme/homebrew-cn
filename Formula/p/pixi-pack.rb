class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.6.tar.gz"
    sha256 "33d9c3fd58bb50c631825d18328c2eac070d1db4486fdf85f0e347b16904a944"

    # Backport openssl-sys update to support OpenSSL 4
    patch do
      url "https://github.com/Quantco/pixi-pack/commit/531711a35df83d569ef3a76acafb27e01d12d917.patch?full_index=1"
      sha256 "405c888e69e7eff2946cec0e425fff5d184736878a0effc61b8d9ddda8383260"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1dbea14d99e90249d30c7d0e4d7a567ea0bdc23e7a1b12454e89bf0361a14b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acbfffa35c67defc83f039d9cdf82151db139706345288fd7965d8be237a9559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e83e8565c625f9b9855928c5ccb0ba493c2fcbfd79e42e618dab83e6eadf48f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b881216aad9c8efdb54998b5ddb0b3534868ae9ad770b736b4caaa3f2c51b560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fcf1735467403241e77bfe17941ba9ba882a4c446038087f07b400d1a503f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd5766b671f8eed625f2adaa81a34a2db2a28ee15186f24227b432f5e4bdd7ab"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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