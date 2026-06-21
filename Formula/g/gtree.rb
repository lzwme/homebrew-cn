class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "03b2b060e2f135b6ec4239b3c6b11061797ac13213383fdbf69478e3100db7e3"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cd7402fedfb69e3c835bad509a75727ce00b3c2ee00006721c0a120a3cfd4e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd7402fedfb69e3c835bad509a75727ce00b3c2ee00006721c0a120a3cfd4e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cd7402fedfb69e3c835bad509a75727ce00b3c2ee00006721c0a120a3cfd4e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1cfff0208e2433302889b43bf896579091f3e5349f0580c2424ac4bd79fc957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed02a78395e545b6655e9984ecef676ebe1c6f8f9d017393e83201952801cd37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d126d5f294064f14dcd02dd9fb842199d2e09ddeb58d2b4cb60c8e18c8313f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end