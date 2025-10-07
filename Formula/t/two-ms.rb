class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "819bdc65f424b128eed1e512166e76e86627feda5288fbd963c6e1db7a314a0f"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4843500a87a64d59c6c28aac1b52a67f48d321ac0d64b5b7dd2ff742a5fef3b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8372347579a855427138edd6e4edbb65d68201d6d50e189434645721e35f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f82aa6ccaa8f7418962395c1e452ea06b3a1a3f9f09a9ec96f610e3fed01cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef49b0440cd3c6c1242cb570a2f6b4d4736393f9a5e9ab40e9ec64bdc4d50a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52c150507fb7a9b575cdac074b00a5c4b357385385740fc39856edd6feaf5953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b81f216e16ee906077ab3b0e22650f6d3440f6a2c008caa868fd9cb70dd6d73"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"2ms"), "main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end