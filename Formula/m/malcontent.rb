class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "10ab779459404cad6a2b4206b84a9b52a2f05610227a902f1a2e651eb1e48dc2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4e250707c9aee72c1dc550dc95e132e05a52633992f24dc0f33cd67723061a88"
    sha256 cellar: :any, arm64_tahoe:       "f3fc1d2a559c67c2e024c2b2916168b445e1f982f612f8afa37ebdd4f7bf91a0"
    sha256 cellar: :any, arm64_sequoia:     "0a40350c84468b8164576dbdde98d79f821b1076e7ce1882090f137eb059918a"
    sha256 cellar: :any, arm64_linux:       "beae4b2fc76c555d81086b2159f022b085a08379eff8d1d9acbe81c338f85519"
    sha256 cellar: :any, x86_64_linux:      "3e037617936b97a47ded9e14fb405bf6612e7e8066ad6b1ebb55b57150c62896"
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