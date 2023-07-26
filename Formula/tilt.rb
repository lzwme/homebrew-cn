class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.3",
    revision: "16d65151aa05de48612973294c0079654dbfd407"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab34cdc27404d1a344f78fd90d61cb4e8c962c7109750797eedfe44abe42717c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3312bc38aac4548a5d6ab0064ec6ddf8db4fd7f7eee8abe563ba589a19fabe5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29b6454919d9e464df7733ef0b617251839a7a4af8efa94d9e0b62a841e5094f"
    sha256 cellar: :any_skip_relocation, ventura:        "f27f9e111fbd4f4fd49234278a21d572fcba6dee186528cd1ea279d6cdfc082a"
    sha256 cellar: :any_skip_relocation, monterey:       "9d3e349d8e5f1a6221c3d89b7cf98c3b4ea089f953a759d91198ab1fbe31054d"
    sha256 cellar: :any_skip_relocation, big_sur:        "930e61125de485dad50b2af1b5112c73c89dc258d79cf9bfe4414b198bf81286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca1b68bc7843c6416a68b1f97e49abb39de92867ac76b8ba182a049bd863175"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end