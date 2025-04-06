class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https:github.comsimulotimmich-go"
  url "https:github.comsimulotimmich-goarchiverefstagsv0.25.2.tar.gz"
  sha256 "b8a968fa5e1c1217f77b825bb4e9548adaf33e1682c052576a681a8bc11995b7"
  license "AGPL-3.0-only"
  head "https:github.comsimulotimmich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4bd96dacbc6f4e9e1b7e1a8a1ad104827ecaad968f5023db589241c3e51be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39a7e564d5225b0c457f35ac4098dc8f754ce68eabc80f2e64e68a8302b6d8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d43c2d1ac1d636d4b4bd2e4a87e42c25b4932bd13599794fdcbf8bdea4202dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5777516a384fa42b9d9090e2d14c19e1778e54e93790a101fb49638f76e5a4"
    sha256 cellar: :any_skip_relocation, ventura:       "ca6891493c5985516af1c5ea04863b51bafcd6f3ef643daa2089b791d1f3905b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cae94b0e4ec00f0db7e6ffdbf7300c8ae19bdb040cf52909c42782c446c382f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsimulotimmich-goapp.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}immich-go --server http:localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: unexpected response to the immich's ping API at this address", output

    assert_match version.to_s, shell_output("#{bin}immich-go --version")
  end
end