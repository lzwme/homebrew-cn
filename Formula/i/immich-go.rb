class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https:github.comsimulotimmich-go"
  url "https:github.comsimulotimmich-goarchiverefstagsv0.26.2.tar.gz"
  sha256 "f7f28e5564f8dcc9e212de540d1fcd97da42e4e01cbf23783ad75908499f3cd6"
  license "AGPL-3.0-only"
  head "https:github.comsimulotimmich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8a708643bbba7b9920e140ccf8ba2e9f58960ad6c9a2d944aaa01570393b321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7115f84fea56567bdf37f8516922810558bf15c4240bfed51ffefb52eaeffa77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4aa81c30dbcbf3f0fa31a45a87c172811760c17cb677868f702ccc6f469a02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf85afab78a0cc610624e27a8d4e22d250f49a76dc89694ef9a2d634b39af30"
    sha256 cellar: :any_skip_relocation, ventura:       "5b3336520dc28e10dcee345c40b65ab96d6031a280caf898ff442e5f7792f71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be30c5edd7fcde93f8a105d6ef4328f3a13be89e1c4bd10fcc76be562a75e393"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsimulotimmich-goapp.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}immich-go --server http:localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}immich-go --version")
  end
end