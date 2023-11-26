class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://ghproxy.com/https://github.com/regclient/regclient/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "f30feda09a4b280233d28712d640909216e4ce648ac36ea1042ee565a2144cde"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea8d14bf1a925d30720e96644bd3c127f726f2122777e6ec31244c47653a51d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40be581b52c3aca0f4a72f6ebee51b0aafe18f3e9f0de92d58abf6341d4e29cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c563605680adbc78eeb4762770f7bdb8703e103bf3429d0394083ea416e346"
    sha256 cellar: :any_skip_relocation, sonoma:         "d98adf07a0e281b94c8d257ea4ec321b21b33fa10666cd22af78e48a2b06b149"
    sha256 cellar: :any_skip_relocation, ventura:        "7857a3d10a68e190599abcadf67e7bf3be58b4b474e420e25c7750c4fa9de3b3"
    sha256 cellar: :any_skip_relocation, monterey:       "43ec41eb90f92061df3f6b2d93b0bd77c2e8328a12791ea23d5eace64d5e2577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b1b3da8de18df801bd09ec94868d63a681efad7472e51bdac61489f8a33cccc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f.to_s), "./cmd/#{f}"

      generate_completions_from_executable(bin/f.to_s, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "application/vnd.docker.distribution.manifest.list.v2+json", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end