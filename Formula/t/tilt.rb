class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.35.2",
      revision: "eb60ec434a3d40d43f070cced95bc93116a2918b"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "357caf218f22e1fe123226968702cfcb9d35e670de1a526f37a9028acb107b3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b89951af0c741fec48e6f55f0fc4c744ee069cd37f3cd5f7a1b82f28a542fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532d397a840b26663becf1a86e435780746bff0255973b9c7aba849cb8f47085"
    sha256 cellar: :any_skip_relocation, sonoma:        "2306f8077ed2dec8cc3b9f61276119878ee57c3b652f32304a62a1f0e951321b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5853b71fca1dbdb40b5e3f22450cfdd81d9e9058e521e35e744901626891aac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4bd64b3b445a95aaea93de4359efc0e2de52cbda7e105bde9dfaef62c47de1f"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end