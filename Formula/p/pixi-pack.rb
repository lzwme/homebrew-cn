class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://ghfast.top/https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "fb7dd83fe21d1bec2404b883148ab66a0dfd8e55e402bd49de8494bedcd13da4"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e1f9bec2c251e317aeb7d9acfcd3647cad56642a7910d824ad3f92a3489d032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891a70820f9c3481827bd4c32c583c30b61dee68d65fb0a73275585968eac3bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a93926fe8e9104925e6c235d28433fe43904a7a7a6c43b1125ad2cecfb04ceb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "21413365a8ce0c21250191379ab2959311bbcceaee483f167646618515e8787b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe196a525703578e929ed6c14034bbce5768cd3f8299ae0e81fe60013ee62f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe323110368af04b24a1d3c78bea18f94cee7f935dcdd81e224466f7fbf3a446"
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