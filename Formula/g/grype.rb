class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.77.1.tar.gz"
  sha256 "ee5ff61008adbc17d3f47ce0dc7b93ca22e1ef5b50be4ae4b58a6141262271de"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7a10a3f4e834413c82cd4ea53ee48c24b41306e1d43d7d8b97122398937ff00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae46d05863f9449764e196d9f824c73211841c441d7afeaec1604b7220aff65e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4055ba6bf4bc422d0ef231072e6c4b2b88a0a7fe3d01410bbc7ffb48614bbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e553e3292100c33969a9963c15682096df35730646563e257e51d5a5e1b9f8ee"
    sha256 cellar: :any_skip_relocation, ventura:        "65b82f5396d2a2df6ddaf59f03fed25cdbb857a9ad20eab718737aa2926cde2c"
    sha256 cellar: :any_skip_relocation, monterey:       "e87c655d45ce9ec73aae4cc480e132e939b9ad06856f3d9b7142dbaecdc6c3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2030c487a7657929883cb1f50ec62ea11ea371d5e7af1f1940cb5456068597b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end