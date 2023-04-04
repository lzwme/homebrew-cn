class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://ghproxy.com/https://github.com/stepchowfun/toast/archive/v0.47.0.tar.gz"
  sha256 "bf16dbc987ca146390b2a7f8f472870e78f8b4d42331d0181a157f6ec64a197c"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "978e5fbe1989768b0a03bc9db00d47eab36d10e24d130c2324af1f40475d7a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483b7e5f8d8be9f16ab3d010585fa230ee35bc8817bb5cffcaeca6db24fdc736"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bc52ebe929529609d80ce91afdc00cddd9749e2d7b44538ec433ee3d1ac7391"
    sha256 cellar: :any_skip_relocation, ventura:        "5b08004439b9d52ce837349347e025bd28a1e93ea5c72c05562686bc43d57116"
    sha256 cellar: :any_skip_relocation, monterey:       "4090851874ffb5a82cf244c060db9caa3aff9f6ee933ebeb37d68adb39a17f46"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca4884a099d8d43f89a70c5f6f4a7616cf613cb2c0b5963ab5bc74066c8ea3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9310860e2f5c62f5de06dd299345b079113b462069e3a01ae519201b3c9584d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end