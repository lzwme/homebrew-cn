class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://ghfast.top/https://github.com/simulot/immich-go/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "c9a5ba5dd0c104015cfaf08d00f25932ce77d2b7e684a6b9435d062f026562d6"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c6ff8c873e635d4c34329746ea00568085b3a0e345f950a413369207e937ca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6ff8c873e635d4c34329746ea00568085b3a0e345f950a413369207e937ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6ff8c873e635d4c34329746ea00568085b3a0e345f950a413369207e937ca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "42af96644645ee474736c69e38677abab502610b9cc9d2ed4eb35b13ecec8c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ec343d5ad47670f590184847adc928fb5e20d5194895ae1594a1a3785004e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde4be512699ba04cd0a0136cfe6671ae7a08f5b95cf1160b01f0109fb6de2e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end