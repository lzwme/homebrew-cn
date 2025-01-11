class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.2.tar.gz"
  sha256 "730e610f0164971b04d239855b5d032b8a2948219332d4f19dc37645ac027f5a"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7cf638ae4f7c9fe41af78c1d7978cf0bb53d8726302ebe9c385e38b0deea79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7cf638ae4f7c9fe41af78c1d7978cf0bb53d8726302ebe9c385e38b0deea79f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7cf638ae4f7c9fe41af78c1d7978cf0bb53d8726302ebe9c385e38b0deea79f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd823503a5a9131a6fd2a3cf440ea3a7fdc46bc198b4e6483a783c59cea8a8e0"
    sha256 cellar: :any_skip_relocation, ventura:       "fd823503a5a9131a6fd2a3cf440ea3a7fdc46bc198b4e6483a783c59cea8a8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8bd23580b6d2bdefcd47eb3d0d5d83bc3673e747f1c49e77e370d63d50e351"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end