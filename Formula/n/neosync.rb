class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.80.tar.gz"
  sha256 "6cf24d95ad9563fea340ddb87cbd918a46d8d500dee45fa59f0b9062037cc338"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae55a83544002ec11f32486afcd24b86c74ce8e0f94161cf41609e3490576ff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae55a83544002ec11f32486afcd24b86c74ce8e0f94161cf41609e3490576ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae55a83544002ec11f32486afcd24b86c74ce8e0f94161cf41609e3490576ff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6abdaf97bac100084bed1f9e59b516abf14a7aeaa594858777d9292f7200f886"
    sha256 cellar: :any_skip_relocation, ventura:       "6abdaf97bac100084bed1f9e59b516abf14a7aeaa594858777d9292f7200f886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e871dfe6ee77765f6f5f38635e77d3d39f0089323f042e4bcb66136897ec6b89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end