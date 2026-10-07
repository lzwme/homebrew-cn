class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "48c47f60da18da99ce308de8a4ceb929e59857775aa1148c248f168a9ed5f0e8"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c2ac91f3f974ba3b8d9557b021511db115d838d26d0a3eab9dc3c4e701aea89d"
    sha256 cellar: :any, arm64_tahoe:       "ed081340144e1ef78f544c834ad94e2a2c4c810eded1f68f8d3beeacbc330d31"
    sha256 cellar: :any, arm64_sequoia:     "dcc707b6159fe618b0d115952e13820372a3e01588274af5fe9588c5da9dea74"
    sha256 cellar: :any, arm64_linux:       "4ce4d057c50e9001627628ce8561f61386b41fc56d5c8b2f43da6d4e636a3657"
    sha256 cellar: :any, x86_64_linux:      "fe906c23ac386a9240e665471985179a9d36786a89c6a9ca9ceff86042f80178"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
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