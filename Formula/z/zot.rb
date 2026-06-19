class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.39.tar.gz"
  sha256 "710f10e788a8ee44c43e70b4b6a65ddcca2f8bee22c1ba84ca32744988da2094"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8afb8db800a41eab194a1c1735449df027314c618280208c76bf7f7f17275944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8afb8db800a41eab194a1c1735449df027314c618280208c76bf7f7f17275944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8afb8db800a41eab194a1c1735449df027314c618280208c76bf7f7f17275944"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f1d143fdd1a1dae0cf6473ea57cadbcc86370925959b5d987dc91470da917c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d676c939ff720cca62e7f3d1ddfd2c5c092f487627203c680fd84493394f2b4f"
    sha256 cellar: :any,                 x86_64_linux:  "5dbe94e13557bdd3e58662dc2fc06f13c3cba0e205c87a4dc25d35aaa43f7543"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end