class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "3d8e8588fa653ee6c7579a1707b95231d6dc18e70f503a0f8b6be5553230f40e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0046ace623008401e01f33be12b0701f92e22095977372f783491402453cd177"
    sha256 cellar: :any, arm64_sequoia: "7389d6cdabfe2ff0365b7bab6e0c34fc4128b25ea40ae630e213be719556b76e"
    sha256 cellar: :any, arm64_sonoma:  "c36e870aabe2594006732a71b86c7b0366e9e03e903ea9a0e13846a4f7ba948d"
    sha256 cellar: :any, sonoma:        "51d973e94d5f77371442c2cbf9cd823d12ea8ca03d4acf505bed3c715cc4a350"
    sha256 cellar: :any, arm64_linux:   "22ec8c2492e664f5a7f9e47e9e684e5b3aab0ca3dd18a072117141d6e1633f8e"
    sha256 cellar: :any, x86_64_linux:  "36f6f254fe4c21731615609dc1a5ffbe7fa965547ff2ed6dbd3cd37b892e5ff2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end