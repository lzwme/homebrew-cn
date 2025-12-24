class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "c034527ed46c55b7ac896ce41d05df7425531343abcc97001eb020065e744d3d"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2924b83c9c029f39c8c9290312a3b330d5f340d756f70795809b249a9e1cf4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a86d1b128e257c3923859a687a3e9ba1bc0c15954fd27a6921472c1bc98b69d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f142b977f1e988aa9568dd1ddf51cbababe517c279ad8b5585431c9890d754"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eee68ae0900c20e0dc31cdd7ecf9d09bbe4f2f3f5f7fb7d4535e663b9c2bce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8d927b37440d672ec759f16877ece267ae75d3a62077c9b20f0a33301d3841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f86df19017e08151f9d793b5cb817638c8cfaa1d5f30fe6371373fb06cc647ec"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end