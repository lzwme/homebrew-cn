class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
    tag:      "v0.33.15",
    revision: "15cb3a6f7e729e1c8ca4b9a510bcfdeed5e7f76a"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "199409fadb7500dfa8e3afc88cf05f3d29bd34ba77329e79acc3db1030968785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9dafd3b76c4f726467741ca3d303a353caeeeb58af1d91175800fbd9fa6f16c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31150e1c9c41c7953ac42838b501f74a670aa89496319a6b35d8a86f4c5e562c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fedc26d2b5e8f9907fa89d9fc885cfd1c8c6dcb99538bb9a84480e4779b75e5"
    sha256 cellar: :any_skip_relocation, ventura:        "5547c3163f6143bf7f19f6c070c926872e910d3e66349830706a1237c5e4c80c"
    sha256 cellar: :any_skip_relocation, monterey:       "a296c42e662642f6e871d8b9ed6eae579945c8a39597aa953bf7b30a3259d640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0ac63e64115262fdf68a0bfc874b155d9e6586435cca767b8ceed1365645f2"
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