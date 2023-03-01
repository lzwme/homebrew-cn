class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://ghproxy.com/https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "e78c7bb52e25f08a655ada23266e4bfa70ed00e0fe836176acdee44449c5fae4"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f202aea68852655c189183f366b1165f2a1cbe5d6370159bfc47fe0b38babc97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f202aea68852655c189183f366b1165f2a1cbe5d6370159bfc47fe0b38babc97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f202aea68852655c189183f366b1165f2a1cbe5d6370159bfc47fe0b38babc97"
    sha256 cellar: :any_skip_relocation, ventura:        "ea59b59ab99a4a8da9b94d732488bf8d0462a941ea90c9f894c0ecf234ee4a8b"
    sha256 cellar: :any_skip_relocation, monterey:       "ea59b59ab99a4a8da9b94d732488bf8d0462a941ea90c9f894c0ecf234ee4a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea59b59ab99a4a8da9b94d732488bf8d0462a941ea90c9f894c0ecf234ee4a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df138dba4a63c1d1fd5e09fccc174d241b23e71c24d9b4da249d5040ace08b69"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end