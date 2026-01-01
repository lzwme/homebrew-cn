class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://ghfast.top/https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "d1bca6ecd8d245e940528b6dba645c5a2e5f6293a3901d5b9166834e0aff4da5"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee81094e37d53fbe7d1a5fc633c407ae823e1a39527cdc620b6945180b821f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee81094e37d53fbe7d1a5fc633c407ae823e1a39527cdc620b6945180b821f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee81094e37d53fbe7d1a5fc633c407ae823e1a39527cdc620b6945180b821f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "65f0cfaea518c041f9feafbc4ece8dc7c21e6ee245f913bc2813eb6004f25fec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8157ffe8259a6710f23941b4bc301ff2f910cea882b6314797735cd3edcc5520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d67e9a4969775d536e5cecb3b6c03b469b75a3844d9441e8848514b432279c9c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end