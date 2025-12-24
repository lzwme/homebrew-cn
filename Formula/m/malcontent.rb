class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "fd64e675d4025b4d5551a4d57b1cc9c3db789eb67f98331d5e5a50da2c980437"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00f1cf286ee72a54aef54e125a087b81de3a7c79788cd62bd0b3c1fd9eb8a13a"
    sha256 cellar: :any,                 arm64_sequoia: "34afb997f70b64177c033940e6557ffd12aea6afcc60699ef8355f21f2a380dd"
    sha256 cellar: :any,                 arm64_sonoma:  "c5a97898bf9fc2ea35bb8bc4551dd9cd07e1d405cafd179dd04305a9c9d06e3b"
    sha256 cellar: :any,                 sonoma:        "4c5e5ff3f485131355c5a6a79436a9bd4a3bdc0f3b38a98e725d5b920f9fdb3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04dbbf12ee1b00a5d9d94d90d5177dc20d8e9577c9808bfc6801a20afc64245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f269e32f1775c8a2641a3460db45965a55c056e345c2821cd3a8586bbe76a3"
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