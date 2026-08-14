class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.5.1.tar.gz"
  sha256 "f7e497bbc36a5e7455af5fbee13ae81fb6af8f8a691211947f329ac73b0a59d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc8a51b60f37722c14dfc7e5a06c47b196b8777a320a8f299dea32590ec41667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a418acf1ffc1cef1314793c02a957162912f05cc62c8fc13511e838d976f8a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b9f6b1b77ea9dca57ea68eaaba8b6502de0172b4a188f0b5ef25ee189ae1f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10950e7c6de383023ed9afd657b731f403447109c0c4cc89c0ab78b1b43aa82"
    sha256 cellar: :any,                 arm64_linux:   "9e4722ceddd04cbbd5030bafd29710d353ed25045fdd3257339077f80d3c53ea"
    sha256 cellar: :any,                 x86_64_linux:  "70f9bffbe9291dbeb6c63385e0fb5bd58f6ca9d50bb0916d91201cc16d265355"
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