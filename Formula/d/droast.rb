class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.13.tar.gz"
  sha256 "9dd8e5913a7cff2822c1424207ff3ffb3761197795dd4ddd2cebaeb834311f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b00f3dfc4a8b7bc692d3fb2cfd045f83485edc33d78cc86fa7bf5f64e54b98ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52cfadcb7ae697cc4d285a60a78c1c2d3463b39353a7d0cae0ec3621f4a75ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85e118273adbb75e44ca5c8d82017070904f50afa4e03d56a437e81643873e28"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc6d52fdccc4f701d6467cf1b2fea94b95dec2c6a06606f9ed394709347a17a"
    sha256 cellar: :any,                 arm64_linux:   "5d82985dee1b589a018cce62391f8bd95c0702357e162a6d05c350146ddb00b4"
    sha256 cellar: :any,                 x86_64_linux:  "6bf41d2766ddcf487023cdfa2e228e64a7e19d8c7250526071f1b994f66e20ea"
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