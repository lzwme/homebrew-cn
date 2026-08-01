class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.7.tar.gz"
  sha256 "2e0befd462afe04a7e1e4e54d656506594aedac9dd97e94b8f8a0643b7fc8e1d"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b586353cad6946e15816f81a34135df4abaf9667da8341d2af5e5b63448c318c"
    sha256 cellar: :any, arm64_sequoia: "52577ca158a8fc3ed162b4e6f76f05222103cdc0f74090b46cc0823c17b94b61"
    sha256 cellar: :any, arm64_sonoma:  "1f4530137e932de1cb93f0b9a9a9c7c50fab75891d234aadaa58ae629788be6b"
    sha256 cellar: :any, sonoma:        "b03ffe85545749d6c7c50c9d152fc4995fcb9fd52f307f1750a8b7a823dabb65"
    sha256 cellar: :any, arm64_linux:   "d32278e37f6a3273406ab2c598cc9f399f251ab15974706ac4cb49127ed51656"
    sha256 cellar: :any, x86_64_linux:  "a0afd084b34a747d6041960e45bbf28323a65a9a53dabb952a7abdcb374028aa"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

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