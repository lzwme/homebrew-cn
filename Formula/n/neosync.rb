class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.70.tar.gz"
  sha256 "4a7350cf4fe9afc5463557d18d72de69a769c4937aba91b3deb0304b9bb9a7eb"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46d3eb90f07fee892d018f431bf83e63a87a21336abc499350a17a8ef3677955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1997cb31cbe5d06166f0800ca93e534d43b9f7ba563b415baaa91ed0a15aee51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62b50f34792c05c116e0997fd39f71038961668da4f24cd72578ed2171d6491c"
    sha256 cellar: :any_skip_relocation, sonoma:        "51213e10c6997e2caa74af18ee12c9744458550c1810dd4bdd9a2ac23326b63f"
    sha256 cellar: :any_skip_relocation, ventura:       "02cde77864328dc0d6c7a1916d5068f941a40e42e559cd5cc99c3f41ad737d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e49891f7063d5a2d857434671f7c09bc270f45a3a0c943c6b23ac1a5ffd585c"
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