class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.6.0.tar.gz"
  sha256 "859b000d04048a30cd61c1e08d75a03690b6d95ffd4dff96af7bf731467253fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8d54ab0475db74a5905251bf184848bf66ba437c9a7e1018b8e3df3ac991cc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81e0e2dedcdf94e425f3ca82121bb241d8f2af6ba52467508acfdf0d1dac90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0573d767b46be40bd6a2e4b252c55b4cb608e201f77e99762f77c71193c3940a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0e01cdf80500df68206aba283e8f9a8ea53e96c5184909c97fdc67f4d472af3"
    sha256 cellar: :any,                 arm64_linux:   "f41da3d8e1482331b31ab05d87a039a3e27fa80fcb3e9357c3241ce43e938a59"
    sha256 cellar: :any,                 x86_64_linux:  "a531cdaf921d99b496eb9bbe41a0c3f341a32d7400396e7aa69256448bcbb0a0"
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