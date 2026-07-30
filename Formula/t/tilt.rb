class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.6",
      revision: "76a6dd7d311178fe864baa22ce63a2f053764efc"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "301ed229ec361dc1fc7ed43918e604cab1e2c7e421ac6754298efb8f0d1af05a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d45c781a1a26d5411324c33973565c01643007edee8d48075c8686deeac211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11073fa1e3d0edf89cf285cd6c419bed0919ce528c68e432da83b68846269539"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8edfb0063439ccbc63939d8e5f3279ea447d1836d2fce433c32ac58c645d36"
    sha256 cellar: :any,                 arm64_linux:   "7193936000739e8f1d65a153be04ceffb4dc857de15661be5f1019915a7c5d69"
    sha256 cellar: :any,                 x86_64_linux:  "9061addcd9f6d2f7f22fd486b1f4de5674fcb2e39209bced66a6f31d32918bc8"
  end

  depends_on "corepack" => :build # for newer yarn
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end