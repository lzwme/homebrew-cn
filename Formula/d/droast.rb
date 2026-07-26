class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.11.tar.gz"
  sha256 "dd05d491c9556bdc3b5057b5a435d3fe004fab527a6dde3d645345d5678acc2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd7ddbf0a69309d8ce3182d370990e1168a41d3484809883e72726a549dc0773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "108fff11ba163d828ca9631b7171bd434d0471b4126e9944277c5465db4caf33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7afd9bd95ea2a0c7a13984765c76ccdc2daef2daccdb72fe782ae8f31ccfa5d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "865766cd0bc65b8fb62611a7474cf82fe9044e4b716c0c07c3351fb91fd23026"
    sha256 cellar: :any,                 arm64_linux:   "fa1cb24b9ef1c38344899a93720aad9b60754e0bc4495ad4a3f882fbb8e753d7"
    sha256 cellar: :any,                 x86_64_linux:  "a9d8ee43b44160381a6539c4d41ed3803671dc58a3a713f1066dea93435ef701"
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