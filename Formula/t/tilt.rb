class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
    tag:      "v0.33.12",
    revision: "a7eb176c4573ac68e8acd5ff10091231f7f72c44"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "658ac6f9b90e5d250da40646cb073fbf5fdf67e02eb34bacc7e77285da8fe7e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5b159fcf977ce23aa3521f2b15fada73d53f51916003d44ab08d15001b7aa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4d7b9f5e61eb93be20eb69f9e3b5a900c722632b4f49c04788b48b167fdd53"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e7720c05b5f3e63dda3a56f31fb82c96316078505fde7c96ee1d485022eba9a"
    sha256 cellar: :any_skip_relocation, ventura:        "8f97a52b0e7b6d67ac13002031744e6d8410f298538a1bdad8eae0426706f598"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5777ae4e86891f1a859319de2978b41fa666358b6c12c3350686449d0a71d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcec8de0ec32c32c0ee0c9e9e6b85b863603325bb8bfb9472162085f0fb4b40d"
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