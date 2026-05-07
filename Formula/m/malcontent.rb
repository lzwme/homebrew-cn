class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "2480f32fb0da4779960a4ae114cdb295ce73091ac6b0c1378984dc453796a865"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "142eadf7f92337051b32023a256164d880c48ad3859d9d30224b2105a6c37cfa"
    sha256 cellar: :any,                 arm64_sequoia: "ea3ff8c6235cbe563d8d9b87cb06d0909046382deb1b0bba5b2299e8985a01df"
    sha256 cellar: :any,                 arm64_sonoma:  "26677fe23b11860d332cc982fa26063e56dff212d0ee9cd9aff06355c9ed89ac"
    sha256 cellar: :any,                 sonoma:        "7ea8e5bbafdc712243aaca58cc36b85cf1dcad59ec508c263b399250af68b8ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70842c942e78298a1f0a77d2c3c07bfa293e1b99b9b29ecae6868575fe5dcec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72096c9c0d9bc27864b8256e3978c7c706709485059059228808fde7ca2c146e"
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