class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
    tag:      "v0.33.21",
    revision: "3e9bfda3db8f49d91e008d7ce1fda26a1f3adca0"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb620a2154c967ad9eed5dd0c7bc70530c00ca4076d464999d3d69f26a1191e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6aaa002d2778e31287678bf62aab92f1841d0ac7d850e74fd2f1dc65b13dee1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80e197a18bf4896633a3f545f7a1f3dc2ecbd83730f66f6314f339a708c35b8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "32c42dc6a04d1cf96bb749f7955fcdc119304ed5a84ab2cd9a38c901006c6bec"
    sha256 cellar: :any_skip_relocation, ventura:       "426d96bdbcf3e011774623af73eaae1babec1b1e3e2793fd1e43a5ca03fa9151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724cab2a9b03cdb7d42077425452df2ee2ab53f31f490eca72e166fee576c3a0"
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