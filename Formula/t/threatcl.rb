class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "02b10328d01bde67347d9ebc886696e7f54d7be70ad7cb37c317f4338dbc85b1"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaf7c0fb2038fe21de69fe2cbc7d3cd129acfcfb8911b6341ac3931cfc4609e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaf7c0fb2038fe21de69fe2cbc7d3cd129acfcfb8911b6341ac3931cfc4609e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaf7c0fb2038fe21de69fe2cbc7d3cd129acfcfb8911b6341ac3931cfc4609e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca21f41c2db96cbffb8a8e26f0d2ce25bc1a32c6381c4f9971ba9e843b0b8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fabde00ce9171eaa3916f97c3d05e108932d981d287ef354440d5570d13b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3fc07411e23e66a11aadeee1b63d41de6dd4caeb1dcd0f816b4242031ef4c5"
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