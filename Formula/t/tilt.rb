class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
      tag:      "v0.34.0",
      revision: "939cd90510a1356c28f913d87581f9f489223ae2"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50377afd0f6cc453f7fc0da6f0993caeb4b9a09570fd783861cfc9330119ab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e464df6424923b2940085080f01f0ecd7c42f0ba582de7d2ebb7e59b9e41978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3288eac9c0442e8a96d79f4d5ccaa183ff13afea43d60699310ee3e502df8e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fb231940c28d76af444792f21dad6652f1a4b52b8043ac1492c61e9bb0349a"
    sha256 cellar: :any_skip_relocation, ventura:       "e3a5fabe7055dd6dba6dba711d8d51ccf5927bed3b72ff6b88339856ba752fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2e1473ed014437cd1359713bf49a7cbdfcd14acdec56d895d23d8c3ddfa130"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtilt"

    generate_completions_from_executable(bin"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}tilt api-resources 2>&1", 1)
  end
end