class Legitify < Formula
  desc "Tool to detectremediate misconfig and security risks of GitHubGitLab assets"
  homepage "https:legitify.dev"
  url "https:github.comLegit-Labslegitifyarchiverefstagsv1.0.8.tar.gz"
  sha256 "c4d22c6a6980b88922a8c7443874829013633d4b6c89abe44be2cca821e3be7b"
  license "Apache-2.0"
  head "https:github.comLegit-Labslegitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "770573182031d7a03b74eb413fcf0e17053a258675eab2d27ac706b09e09e121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c2e656d099706d173042a990c069447c3b8a510766701714d43114d6926257f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fcb5d8ede6128f447146d432a0cc6b0a85d30dc0bbbe843ccd5699cfdf7564b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c52104c92ba011042129f703890df4f25bc132e4087141f1588614a1c6db292d"
    sha256 cellar: :any_skip_relocation, ventura:        "6359fd6ab63a0a0424599f2ad25be8b8279a95bcdb7c352978e2e5dbe12c2dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "11c8bb805101e28ae60ba1733bf3299d17fa5cea04ddadc6bdf9d5a3c12d7cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeee434fa7bf864dd76fe9c319c301e34acefd4b070ae65d67e89dcb76e15cd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comLegit-Labslegitifyinternalversion.Version=#{version}
      -X github.comLegit-Labslegitifyinternalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}legitify version")
  end
end