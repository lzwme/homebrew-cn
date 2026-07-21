class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "e5a85141908a0018eda5239f858297f3fff86e3ed2677e9847a575971959d3be"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "374a0b1693885ac7560b0eb9d083151edfbefffb31b54caa9194efb7587bb8f4"
    sha256 cellar: :any, arm64_sequoia: "1b6bfd52664b99b3e123d60eee82b35e6d418f83b1c8184a6a909a81894154fd"
    sha256 cellar: :any, arm64_sonoma:  "8736692f8a6c17df98c23b2b564b4acc2b1c43587596a56d377b2cd7f4049af8"
    sha256 cellar: :any, sonoma:        "78e48523b3cf24d5f10216f13fad63a4c47cbdbd752c70117154b274982089e3"
    sha256 cellar: :any, arm64_linux:   "263fed9bbe11b2834c382153c6daee1fe90b9fba1fd37856d5eb414e3ab8ca0d"
    sha256 cellar: :any, x86_64_linux:  "99e2d5526364e0a9bbe2e08f336fc2d9dc560096a1954ebb4651a18262b23ef0"
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