class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.7.tar.gz"
  sha256 "19b48fbcaefbcbba564f4dbdd88668a15156c81c81ef923b12e1cdecd3a299fb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e71ab2447dc42feb77e5700a0a8d820aff4e434d272b8f3899c7f6e1754cbfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e71ab2447dc42feb77e5700a0a8d820aff4e434d272b8f3899c7f6e1754cbfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e71ab2447dc42feb77e5700a0a8d820aff4e434d272b8f3899c7f6e1754cbfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "447b533243d029846251d64e52691c20be5b976785dcb8b9ee6d0a21c45b9792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31cee0e053141043633c7440d7ea14db53f9f2b3f66ac8bf9abdde4dcdb4093b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5505ff0d11f26847ef996a4a947493bd9097c455f0e88ca48c68b1a8607f43ad"
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