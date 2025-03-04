class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https:github.comsimulotimmich-go"
  url "https:github.comsimulotimmich-goarchiverefstagsv0.24.2.tar.gz"
  sha256 "9dad15644530e710be4973343f25ccacd8d9f611a748889ec1734a7b2be4fc4d"
  license "AGPL-3.0-only"
  head "https:github.comsimulotimmich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c4c9193d8037b909a417b7238d7ae2405162e40af3bb9d9ff45f91dc17742c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc436d2450cf95845630268d2312c0fa60c89c59da61e054edbf88fbbb5d4216"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b76b38bb5c966fe29b1bbf36ba6da0f68a5ec4618684d6f5510c182d323a2e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fed05607c17a39e33064732f3d02ea9c48778d44e250e38f4988089a85e9301"
    sha256 cellar: :any_skip_relocation, ventura:       "1e470c38324eba025c2cb496ace4a78e32de3bafd85905f7ad49f2d5575e8f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ccb5e8fd5db2cd979cf79dc59207358d714746d871817ab508d281fd8c01f5"
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