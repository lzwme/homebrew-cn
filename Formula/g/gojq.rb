class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https:github.comitchynygojq"
  url "https:github.comitchynygojq.git",
      tag:      "v0.12.16",
      revision: "0607aa5af33a4f980e3e769a1820db80e3cc7b23"
  license "MIT"
  head "https:github.comitchynygojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d3a1f03ff3bb4f6e4de770a27adbf1ec9f2bd45a6596bf28bf35860fbf10988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d3a1f03ff3bb4f6e4de770a27adbf1ec9f2bd45a6596bf28bf35860fbf10988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d3a1f03ff3bb4f6e4de770a27adbf1ec9f2bd45a6596bf28bf35860fbf10988"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b473c2429f8843e306a800f0be08daa2d0c291725d9ac169aa0c4145bd4ea22"
    sha256 cellar: :any_skip_relocation, ventura:        "4b473c2429f8843e306a800f0be08daa2d0c291725d9ac169aa0c4145bd4ea22"
    sha256 cellar: :any_skip_relocation, monterey:       "4b473c2429f8843e306a800f0be08daa2d0c291725d9ac169aa0c4145bd4ea22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "308dc8d13b4be74896a795a2870faac42ff6a0d2684f05f73194780dbf42fee7"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.comitchynygojqcli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}gojq .bar", '{"foo":1, "bar":2}')
  end
end