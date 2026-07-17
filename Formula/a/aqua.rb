class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.62.0.tar.gz"
  sha256 "0eb032bb7f02064385ba49c1397abb23c58df9207518362571ac99b3e5105c8e"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba5e083f90f8239234ef4af1bdcda1e6fecb91e44d5a7f9e2e11018673e712ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5e083f90f8239234ef4af1bdcda1e6fecb91e44d5a7f9e2e11018673e712ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5e083f90f8239234ef4af1bdcda1e6fecb91e44d5a7f9e2e11018673e712ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c2200b355b5ed502ec3954904f6a62bcb54c76aad4577f2a625a0b092e78f64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5d94e6b4f66c15b82c294d831e7af48ff2ad18fd78bef6a1b9c703a75d4547"
    sha256 cellar: :any,                 x86_64_linux:  "131de7efd93314494539406144388c846c897a99898aa824e0dc616520074a71"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end