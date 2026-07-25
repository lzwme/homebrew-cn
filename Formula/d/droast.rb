class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.10.tar.gz"
  sha256 "db6fd85d9162ebf29a2d7d41b04a99247b2648e847b23967bad2e893c976b5aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b08faa5eaa760d73daf7db2ba0ee3a8382673c1ebf9ecad27ac9ae66757b77d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3daa71b53e89224d6937149f3c8a2d747ad62e051604bb06ac15a6fc4a8e09b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6935012aa3d64cc200532f81538581cacd33506535312e6e9c3819a7d26679a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a9e966c755c4547dcf2bcce25c1f362c488645bcc3b8e9fca77ec29ac97bba"
    sha256 cellar: :any,                 arm64_linux:   "9fcef27b4a08f35eca1138e471787ba1792284205cf8f27fd82fa2041d342a1a"
    sha256 cellar: :any,                 x86_64_linux:  "3df0eb6abdb02fe09541a8c9a9270de0483231e576a0f73dcf7fb4c2b03636ce"
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