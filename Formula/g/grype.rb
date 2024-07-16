class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.79.3.tar.gz"
  sha256 "0d596869538a5145432a80c739ba1da0aea32b90221db109d81066da12e28f39"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "830a49c266b0f322322d9f91a70dbebf2bedfe80ee97f64a0466baff4058ea2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c76293faced134004adfeb964e2e8517b37390a2d7bb804988ac1d3f20adc394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe7002c5b583f05c2e7995435253f569ad252a92c84c0f61ce1b5eca13df37e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c926be4796dc0b60aea40517f75fd9279d5ed90041aae1c349c1620361afb200"
    sha256 cellar: :any_skip_relocation, ventura:        "ccee13f6b66e7bc777275babb6d403180d35acaec56574c947d411efe05ca6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "6fab09b0fe04d2d45594b1f48fe7d37491873669cfd9157c3f70629790cb5fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b43e16b54ac77897a514a76d06ce8042626382e7352c64b67e1424038e6e5f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end