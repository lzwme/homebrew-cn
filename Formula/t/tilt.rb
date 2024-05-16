class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
    tag:      "v0.33.14",
    revision: "df9cf55f841dce02874f8f6992f96bd6908432a8"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93b8e9e5dc1706b431a91f23d00f3d513891541bb29ac2fc255db2c92e18dc73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e3f4b9a3cffafa2a17597eefe573812ec27ed2b27069cd8eec94d6dfc903066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b279bab4abc8e9881bc93ef479932a67ff147359d1f5d46e49a1f5fb4f4226e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0861dd982148316b03f30eb3e2d6378d8245ba2875e555c18e46a8109c77e06"
    sha256 cellar: :any_skip_relocation, ventura:        "0147370a7c4551324b899675e095c5eb39af98357c8caa43e6589fecc8ceb9ce"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5bf61cdd22777a113b940da79782d3e5b3f288b4f08399239e29cacacaa0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13771d021293777660a75dcdc156e36ac7c88d12f4e858792bfe85b02eec223"
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