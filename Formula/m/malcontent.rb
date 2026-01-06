class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "5e11d4f88c7fe762ec180cd8642c78cb67d47f0058b409a5e9b680fc88ab2475"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adf6db44af58dcf1c53758b238a93476d5c4b73f55f9cfa362e597b44a459a95"
    sha256 cellar: :any,                 arm64_sequoia: "5fd3adbc8d57d6ffac854c2cc462d7187b65a84c4f47266c6b8e0a2fc342d078"
    sha256 cellar: :any,                 arm64_sonoma:  "e54b770720114fb94013c25e3527af3bd6416851ead275335987b163486bf673"
    sha256 cellar: :any,                 sonoma:        "acc49db833b6f4e6dc15ed6f4c26f926afb68a5660de3c6226dbae90871f7002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb339e42fb0e81d967b2f285bbd0fdb44b830dc13a90b4c0330ed3c3d1ba578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d51c00421501f2e54a42d1a13d7cf8beadc51e9dffbe5f14d4a4ba915b9852a"
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