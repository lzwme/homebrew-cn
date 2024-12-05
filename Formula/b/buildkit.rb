class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.18.1",
      revision: "eb68885955169461d72dc2b7e6d084100fcaba86"
  license "Apache-2.0"
  head "https:github.commobybuildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3cf81c02f36f1e282b2a4df98174b408a8795ce6d89d0f3879372d87fad75e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3cf81c02f36f1e282b2a4df98174b408a8795ce6d89d0f3879372d87fad75e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3cf81c02f36f1e282b2a4df98174b408a8795ce6d89d0f3879372d87fad75e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d2c642c0f3bf9f0c0f0d484b47847c7f403f78708fde14e767efb917018cc51"
    sha256 cellar: :any_skip_relocation, ventura:       "9d2c642c0f3bf9f0c0f0d484b47847c7f403f78708fde14e767efb917018cc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2960380fd1f1645dd7724424fd07a0108e7d1e429dfba78b3921d6f65285b9ec"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.commobybuildkitversion.Version=#{version}
      -X github.commobybuildkitversion.Revision=#{revision}
      -X github.commobybuildkitversion.Package=github.commobybuildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin"buildctl"), ".cmdbuildctl"

    doc.install Dir["docs*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}buildctl --addr unix:devnull --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}buildctl --version")
  end
end