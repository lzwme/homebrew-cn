class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "cf3b07e2869a27e0d0026c1688d56e946705c61d78aabb6d056e7b62eb58ddb0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb3ee56474c38af5971c9bfac42ec1bf5eddbf3c5a3e976c16c7a8d872314371"
    sha256 cellar: :any,                 arm64_sequoia: "95e42e563a2001ae96511c2cb7e5fedcd1ef0ccb36d86a33e423be5184676895"
    sha256 cellar: :any,                 arm64_sonoma:  "ff05425ab19cad99f78a95c6c4b16a87bb760e05e311ade522cd005e09b5911d"
    sha256 cellar: :any,                 sonoma:        "9c37019f4d30b7a5b9bec5851a6876ab730ee5e8c029623a18e6e9b0ac5a8c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4244d8611eb4526009686f059c0109e13798d5975b4519eeb2f0968c6fd727bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96458aad14972d9c891cbc9edc8a4fe6b25c74e5f1f3fc90d38325085a631b5b"
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