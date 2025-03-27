class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.233.0.tar.gz"
  sha256 "3a66010ba3766832ba467ebf67a6be42e891f09d64844bce136d3c9d28b98ec5"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b30cd219735376568c88674bf1b0f0bfd0cf008419ba2ae51d5954e401a3d24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ee190f36861a8ada3907a327838cbef085f03f91e7b1440eb2fd7d53aa7bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a96c485e4aeb1f1fe01cb8b506c9cadd36a95c90eeba8944791cf124ef348f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "478e493117d8cec054d07e38c8c7b8189d49f7a442900014d09221b055ba6d59"
    sha256 cellar: :any_skip_relocation, ventura:       "e8e5d6da8d8f0889449090c0de8b57a6cbb2d4a0cbff0ee904b42291cdb8603b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5333b9e7fd913dcfa0fe3b32b7a7344f6121e40c7fddec7c769a731705eada5e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdpscale"

    generate_completions_from_executable(bin"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}pscale org list 2>&1", 2)
  end
end