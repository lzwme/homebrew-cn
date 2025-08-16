class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "ed3fc7a93c4dddf182de6d33ea9a1a059481204281c79c8d6e2743a174bbd0c2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc71a3e03161793052d5b7dc7c8380e1a95b65eb0aeb2ad176087849f2776e37"
    sha256 cellar: :any,                 arm64_sonoma:  "e82fed003ed53abf39a4834e12f18b1262a027000c4ebbc45fa5483c4272fd63"
    sha256 cellar: :any,                 arm64_ventura: "c65269f00f56ab7a63bab48c113ab62463306301f2b390b6c2a679584fba3650"
    sha256 cellar: :any,                 sonoma:        "dc24c45d4025b4613fb835a90a784223b54bb2ac132600c26854c41b10ece151"
    sha256 cellar: :any,                 ventura:       "2511f12e87db212c5cb83b78f7b59c2d5dc37fef94825698d0ae52c5d33f77c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908239eef1317d922a47f85558efffd0525aee38411de805fcea1ee57a1c8ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffcf83ee0f7d3c7d457fa39eff1ec480db1d675692b3f31cb56f1c295f5168c"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
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