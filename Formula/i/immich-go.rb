class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https:github.comsimulotimmich-go"
  url "https:github.comsimulotimmich-goarchiverefstagsv0.25.1.tar.gz"
  sha256 "334d74a52a975d9cd8e7d32fff2288e03b0c417ebc4de6cf5f1acbc86b45590d"
  license "AGPL-3.0-only"
  head "https:github.comsimulotimmich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d3456e9e13f0442ba572444457d7983ba77f7e444246871592f6142566b441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b625b00a00280c32309bc3e4ecdd8331c7134651f5fa13a48bc8572b1048f153"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87cb6eec65406a2dc611e673d19308f3d6535eb732b5c92ffc951d5c1e5d4f78"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34777e88ee4c1b910e79ce296d157407d417e7376762e3845f920e5156061cf"
    sha256 cellar: :any_skip_relocation, ventura:       "861716652a48480b1c8ae0138e1ce3a76adbe84d317cadb808dfa0c554b7685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef8955ed9c45c20039f268282e8536a12a7070820667272148cf0c7ad858382"
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