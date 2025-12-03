class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://ghfast.top/https://github.com/getporter/porter/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0070fbdc0e7fc0c9e74f8e99330758cf4be5d2719db2b141aa687bdd9bd6ba5f"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16f81b2c1a8c1b72305b0b9d95a51746a06f2694b1980d306c16a79d33c44f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f83a0af09ce081c1d616873b2c5c8896d73b29da3a3f4f2df39871cc5faaab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85768d3fda6e75d332df857edadb526ee69046c60166ecb45a6049441a35c0b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "41cb89598cbeabcb903e2ba2cb5e44e21a804ddacda5993fe1d52c817470e482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aeb0a0286f2c6186612bcf95f98d3080ee0e385abf2535a257ff387cef7fd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f90dc1177f820c95caf57001cc102d0481576cb30d986830e7c035a94fc85ab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end