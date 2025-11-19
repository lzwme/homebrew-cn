class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "a1c34baab98c91b0e43ae12606fe03d2b1899ad43720ce8b6f30a14205d39829"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d9fe69e64c788deee0efe0b9e75af553117b89df25d72e47e1865b7954bf50d"
    sha256 cellar: :any,                 arm64_sequoia: "11d9a67b515b1fac0850c0d0c8f562058f6f89fe44e8f80cfad69b025bc60f01"
    sha256 cellar: :any,                 arm64_sonoma:  "953490d358b45a12193eea091744386aaa2fb428662dc73ee2650d81dd879011"
    sha256 cellar: :any,                 sonoma:        "5f98b1f177ca6c1260e75bd807cd35e5c1d94239621b6137e244a8f9f717c1c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf01bbd75401e63625d519b4ec67b31d01ee115c265479f83c3b1332b732a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6e547e1e156ae27078c7fc433aa27ec7e91b305dca3399d22111367b7b0355"
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