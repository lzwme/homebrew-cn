class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "f3829c965f388610f617745e3d0284190c6b5f5b9e64c9bf799ad891aa670880"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f83d76890933acf35236e089d99027c55a601752ba1fa99d32f2cd87caa101b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83d76890933acf35236e089d99027c55a601752ba1fa99d32f2cd87caa101b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f83d76890933acf35236e089d99027c55a601752ba1fa99d32f2cd87caa101b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e04ca91c93edf089eeb1b6645bb7184da9c2c137973556e1e49d5c31f680009f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981b63b2a30d3590038cb39694c49303e03e4ffe2fe8cf092084909798d5527b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b303f76702b7c8451d45060730870d34db496d6d59d7f8f453f56c22e0af95a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end