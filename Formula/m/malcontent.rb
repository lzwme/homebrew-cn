class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "81a220dc3dd926028a5fce2b4aa93f7fb35f4e1a5265e5d1612e7c9f2fc0a911"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a81afc225f03343e6bf0f04943982b843303babd242282ac3664158221745467"
    sha256 cellar: :any,                 arm64_sequoia: "fb01ba0756cd63657d9b154fe9d8999c6e1c27429e5c48da92dcf3b7a3df50e1"
    sha256 cellar: :any,                 arm64_sonoma:  "70a2d6e60e507f96505fa67ec199dde147535c0831cba39f956008bf8284c715"
    sha256 cellar: :any,                 sonoma:        "4e52269229a11ab95a2cc7b38bbe280848c81398dd0411baa2456ec9e04bf6ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369cb38fcbd796dcae96d0f0b41d87aa4895b2c6281bdc8cdd022b6d652ac593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7908172802b1b2c6a139601f010b705c4b714e51d9bc8ced1dd21ca8eaa700"
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