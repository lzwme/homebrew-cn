class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "8503a56a9669b7f64bc406af0f28e0259461b455a143ca972a6e6ea4644ab275"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "410ac448eececb82e579a2e8d675d54fd8e0fd9e5fa835ae3c1166288eeaf11a"
    sha256 cellar: :any, arm64_sequoia: "d46f3ee0b6aa57541e74c0618eee777f73d8ae6cc293d3a2f0694b8db8f1f019"
    sha256 cellar: :any, arm64_sonoma:  "2c5475149b86a82280ce09110f0287c3bb7cfc4b14414b3fee47219bbbd101ed"
    sha256 cellar: :any, sonoma:        "e55918d34c7119e01702a067f2a8f3dbada9459b85cfa02812e0f91f6f3f976b"
    sha256 cellar: :any, arm64_linux:   "5cabf6e8c4734a33d6eb3303c0f07eaeab5faea4238bdaca48348707e5e5f2d5"
    sha256 cellar: :any, x86_64_linux:  "e4f93f0f6b5f26642c8af879b569d48ee3ece8df2732ee6739aff76c9261cd16"
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