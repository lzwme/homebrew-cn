class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "631fc6b52058e8161a0c205baf33d1bebe378b9e28a06cebdb780c6652be467e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc350d21805bcacf331a3f1b7ca194fc458c911d4f0e8cc6d4f281e1c9bd28e6"
    sha256 cellar: :any,                 arm64_sequoia: "72a32a5a6971f5e56b44ea2147e0067206fae5a6f318e8140b278496cac67639"
    sha256 cellar: :any,                 arm64_sonoma:  "b72226dea790fb657d1801dcc926d2a6058359541cbc3241be4afbbb56cc4bbb"
    sha256 cellar: :any,                 sonoma:        "ce015060835ffaaaa87bc794a65a7c236faf0bcc22d1d3cae2c264ff9ac0154f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dbad587bea9509452bf046f2025ad08d75ce6b909118abc9e896303b20e67ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b723175a05ea01a465e39f0e586d5fcd7a7ae428a321d3b386a81ba44e4416"
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