class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.59.0.tar.gz"
  sha256 "69ff33aca6a20c04d0165a552377d71186c77e84a6bc5b477f7fa9cf99a3d0ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1932a879ce2b41362079d14c6a55f4c0ed3f5e155541227ea80ce123b5f10fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1932a879ce2b41362079d14c6a55f4c0ed3f5e155541227ea80ce123b5f10fc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1932a879ce2b41362079d14c6a55f4c0ed3f5e155541227ea80ce123b5f10fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "afd55d595f71e48c349b5f424d9b1801985a0d57a97644e68c6c0cacfc909d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad7ada4ae1c8fe754d92154bac7429aa193cd54922b41df668ec9bbfaf5cd84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af56a55cb9f4a6540e717768243a32e0779074a445f373f32e7523764457e957"
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