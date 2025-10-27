class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "e3900136d0bf6b6947d521141eb7baa06259aa3b4a0e747493ca819470ae3783"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "841b53d7bb0a520a633041a318c0aef4cc5a726e75e55d5b940880c6443794db"
    sha256 cellar: :any,                 arm64_sequoia: "435777235712bde4d7b2be5a71af5bea46fba0ab28f0af5f957e7f6f7c2689d2"
    sha256 cellar: :any,                 arm64_sonoma:  "0ff80cfe16d4c01c782992cb77545a5fe26f059dce23484fcf949f604274608e"
    sha256 cellar: :any,                 sonoma:        "62011e5c6ae520100002f845751a085a4b3fd6187a8dc284c09141b92ddd3556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb09a5364d0225a27960df3e139e60d9f264ddc507a32601515f85f2c4aacab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2fa86a0d5f04614da235e2aed20525ed819bfc262d59c372ea52d6d55cba3b7"
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