class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.60.2.tar.gz"
  sha256 "c3967ef3676d415560e2150931ecf6449ddbba37ba588bf186b9b489d98ec1b5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36101bf42b03e929f62866dbe30feb1eea5fbce003301522b1e84f184e59239d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36101bf42b03e929f62866dbe30feb1eea5fbce003301522b1e84f184e59239d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36101bf42b03e929f62866dbe30feb1eea5fbce003301522b1e84f184e59239d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43fe12b126139e8bd914d487e4e6a842eb8aad4964e3c92086050aef5b7eec5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91d94e1ec2fd6c7d1dd6de0166b89e1df0f6f94d4f2bdae1970c880c0dfa6f1"
    sha256 cellar: :any,                 x86_64_linux:  "b8505b507c2b7bd5e8da142a677a3afdfe97a52073dc1f35566b4ce2a052f68c"
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