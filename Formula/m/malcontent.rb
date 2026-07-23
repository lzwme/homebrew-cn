class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "b09778ffdbb09ad79eb2fa286c66c3013d8645c856ce28872225c9086de84dbc"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6337846706287adc71f4e493659f89e059785b766a7b376d7eb4a4116e822850"
    sha256 cellar: :any, arm64_sequoia: "722deba8613b32b706690a303a70b4503564b84333e5aad3fe499faa3f7f80ea"
    sha256 cellar: :any, arm64_sonoma:  "23d4d74930d713ec48f06e95dc2a1aa3a25b3a4c21cd4027215e45ba35b252a4"
    sha256 cellar: :any, sonoma:        "e8c05a2fcade988c9c5bdc0ef2a4491b33d5d8a48e514f980b05148e24c22c9c"
    sha256 cellar: :any, arm64_linux:   "11ed64870564ad8247b4ea4e218ebbca1138f594a7f4d272e0ce1cedcdf944da"
    sha256 cellar: :any, x86_64_linux:  "1f1d6ad7cbd2f668ee36aecb6ffe7a732c060efc45a5410432b07ead697f8ea1"
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