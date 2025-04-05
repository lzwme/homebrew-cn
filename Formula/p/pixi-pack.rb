class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https:pixi.shlatestadvancedproduction_deployment#pixi-pack"
  url "https:github.comquantcopixi-packarchiverefstagsv0.4.0.tar.gz"
  sha256 "a157edac4f8fa8c60f9512ad3f7215b41c6cb747cdc9043ca420eb2a7807bf22"
  license "BSD-3-Clause"
  head "https:github.comquantcopixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e34572afcd6324763b9a3513015da4501914d1a6c590116b6809ee53695b2906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1cba529a25e1e341a00eef7847711dc982006723f355bf2037583f92dd47ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94a831c3a6b2d0fb8bf4af2fc504c9f68af5830b904b267d50866e150e03f1b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb71719b46fcd91d67015eebfc1401931472fd92e65d5ec8bce68a643f8458ce"
    sha256 cellar: :any_skip_relocation, ventura:       "a3cde144d138ed02578c0d9e2f4aa0666dc54fdbb0a008d5ac3890bf431996ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c503774c670040bef31518de37462c500cd7d3587c4ccee50d520da917b88da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944810da282bf6b4943e1458532a6771698a73bf99f2d6d19239bdef16f07e9b"
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