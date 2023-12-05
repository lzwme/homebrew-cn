class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://ghproxy.com/https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "5716e6abbb83b0ccc607226cf45e4764944ed2858af4914718ad88dfc4783101"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df8c22b8d56a4c7974c4e36eab3f57ed4fabde603b76633c38ff6b999b3b3f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f20638f7027fc05db12f6debc81b5445e65e5c20b67ea8dc5115701754151a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a737e0d77de8cb3645b2735c3ea02ac684dcdb6072edc29178f44cc5ab0bd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdc2980c5ca8bef8d979b4d351f963967e13dcd4ea550424c8e7c95a7183c755"
    sha256 cellar: :any_skip_relocation, ventura:        "7a43549aa276c495e23ad58f33a0bf62611f7d98206e7171a7b08296623e8ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "db7d674b271a0d24e6fee3bc0f195729775fdd518dbc8bbc1356f0f9d6d6237f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12ea1bd6803e790bc3bb607c847faad4ae71cbd8406a7a4ce39df5bf2a0220f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end