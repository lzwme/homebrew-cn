class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "c19e28f3506e76ec2716ce85bdd13e8509da1f99e67acc0ea4c26d1f33773ba0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8fdebddc42895aad49c81e0dd3ee95cf294ca4bccc043ce356530f9d45a512c6"
    sha256 cellar: :any,                 arm64_sequoia: "e7e85fb381e8f6505a2b4cc9a2e92a4c4d8dca31080e2a66d9d28a55b19b63b2"
    sha256 cellar: :any,                 arm64_sonoma:  "9704f016692c3e58e3ade79b9ee0f48f61c74ebc727a2fe74361d3e2284f0c68"
    sha256 cellar: :any,                 sonoma:        "9ebf6030759b92700b680a4df71de03fed4acbe7cdda6529c6b81b7ffe9bee86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f03e9795e0c69598c67bb7301e352fcc540c6d5240716fee27d3b13c34e391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b64c547158f69c27764a1dc9feba97bf829d2c10eb25fa4d8cb01413398c15"
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