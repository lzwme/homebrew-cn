class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "bc9189ed77c8362886dee3bea7c9e638f5c461f245674f82f5b0e8b6bbc58c8f"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f77da9cfb069023c176d15f51c35a457e1c4c1bc2a256ba7c9252298bd5683"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c597faf57f39cdb7aee53574ba7df46fd6f928b4878372b5a0c91aa62363aa8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17640b09e129eabc207576793a7bf7fa55b6deec1bd4a184b5d60f5b97796aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5cb2f5aafcbf0dcb4da9916cf26a0bdbe52a6a202f120da7d8137d550dfb9e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1698365e5d684461184f430a3b8939d59402903a4d99ec1be1dedfc2062de64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b62c012cddc06455cee8d9b5d46cec9d13005215b35e443e7414aaca34eaf88"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

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