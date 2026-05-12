class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.8.tar.gz"
  sha256 "84ebfdfb14eb33e3774209c0117a0b5bb491598e257c0bcb2ed422f5639c633a"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c87e675dafc9ada5f15d40b822deeea09729b5e5b070e00caa5123c64b70534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "394bd35d517a359b1974403f59f57e35888b693d38bacd6ea804a21c7b0cba7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da63943c65a0f585a3560a0980f2fd6de0a043b69f3f1dc17f09ea15eded85e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b67d9c48b878eab2a1c038c7e944dd6f2a7b33432078e496f4e97c64f47ee98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a2bc800679c0ea99a621e20791df70930da44bd06503cd8fa32dbac8038eb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f0002f682d6ab002fceeb757f9afff3d68e938e2ff9ec44644ef1aa10176a9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end