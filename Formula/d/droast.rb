class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.5.0.tar.gz"
  sha256 "92bf416fbc305bd9313c1aa0f927446369721eab39b3e23adb7c90f49939e3fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe9c5137afb7241e6a447aa7afa799eb9fb3391349f5d91c6e9a9bd43eaa78eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42fb3de2afd5d203f7c481645ae2130adb2ba0c56537d4238aafbd95ef30f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ccc0071bd6f89a4e0ef7046b05ad8984295a5b661ad4daecc0cfb15a5412122"
    sha256 cellar: :any_skip_relocation, sonoma:        "e95b421d72fb3889cea991b4cffc2f54747d04b66b1a303b0910411abdfdec02"
    sha256 cellar: :any,                 arm64_linux:   "0771e99edc4db30ae32b4c6ed4d255163d175c0582cf4a86914b9e8878046728"
    sha256 cellar: :any,                 x86_64_linux:  "43eb60f31ac7fed96de4f96d08b56985966259d8045eae0a495a262a05c80881"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end