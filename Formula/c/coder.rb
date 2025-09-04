class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.25.1.tar.gz"
  sha256 "908742c5c70eb92288d9f14a22588aaf9a3bfdc9102d2b82bcb54a480833b0db"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e66c0b6545a2d20fe9d5f0ad4c364907ade40c0aa604172ef83e00d900fd4edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3029726de21a31feda571257e9c59fbdfa657f0fccaced06cc4cce5ed2bc8e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb599fedf24fc6a2f56bce67faf1767bd25036cfb366544813ba2ac38f7588d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca38961445bb4d30064e15cf3b23dc2718e812a1fa762806d6d83b7b308109d"
    sha256 cellar: :any_skip_relocation, ventura:       "639b37be873e7f39bac60e27559e2d01e157e5e303426faff2350e3c96020a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232248bf6e63c914f857a3132befcb1904c7023bf8bc96c911f43a3daee687a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db340989782d78bac15c3096f4a2f782b4bf9c2f511a299573af172fede4b643"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end