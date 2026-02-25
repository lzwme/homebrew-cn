class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "9d2265d209ba71438dbad1c53d1248965e53309674aad0d1622889e585c1afa2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a3340047025c20a048cc4148bdfca8f433f3e3fe60da7284d84c62b54361d21"
    sha256 cellar: :any,                 arm64_sequoia: "b3f562585ff3d4daa87181701e956a2f4c87a060885236b1861d3091bb2ab736"
    sha256 cellar: :any,                 arm64_sonoma:  "855a404b17885e87dfe680c3eee1e9a644027e7eb5f4a7a74a11bc04ee79be95"
    sha256 cellar: :any,                 sonoma:        "aa61ae9d61492dca9aafabd70ad98982dbdec7067666137cfef9e39b7785e706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6886de316b2a9931bfc9ea8dbfafd54d35d19bb3022f47d080e8d1f906e4d1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55807609cdbe4961dab084d70ab1ccc1cc26a085fd3f49de191a302cd56bfe76"
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