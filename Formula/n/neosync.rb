class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.63.tar.gz"
  sha256 "5f5c1344169d9969aae6140740aa91a8c86acb84f3dd52663a4ab17d815922ad"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "485aceffb9f6242ccc9928151d6b4e659499ec1da14f9acca567bb080498f4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81df608e8e2b2b1379813888bf5c4de045d7b52d50fa3639280608d4857676f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a5614fce095ab9cac943ca94530e2f7fab71e08d925ae44103d85174ccf5c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be56d106b1c21bf9e7938c3eb25354e316ea04f1f7d9221a4c5beb9b42f845d"
    sha256 cellar: :any_skip_relocation, ventura:        "2ae57f66fb86cccf198e0f246909ed00a4fd14366d2b377e36b41457a7ed6908"
    sha256 cellar: :any_skip_relocation, monterey:       "ac9ba2a3a0daeba799e0a9c9c4510b9a673056a910410797cd234136b60396d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3df914da7a852f934b29622079a84b02e84f75d56a3939cb404496271e75b8"
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