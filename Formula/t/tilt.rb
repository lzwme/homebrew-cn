class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.9",
    revision: "8fe41d174c784fa8c5adcea89e4d2a91eff92653"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5f5496970aee23bd3cc83d15449b31baea35a5a07e6f8b6526ef0e0ec00f816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58bdde75382935c7f5c7e52e6287495dd4151d611a9cfadf2c5d239ae025851d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3864aade9dfd3939f52acd3c3433d1deb8370df78e3486bb0788c77fd2a14d4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3680ff8a8663217c82fc01a9637a30cde5d9bdcfd431b5efb82ece811d04b430"
    sha256 cellar: :any_skip_relocation, ventura:        "3dd5a3879c9aacd3980932d87ea26d999a8e71f574c6124a5d3c892af611c77b"
    sha256 cellar: :any_skip_relocation, monterey:       "7bf126687fb8c44c233e2910e87d8963f939972e1592e3fd20433ec29fc0efca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fd49d1a828c838d109767c432a0affa3b837f00ad3f4e9212481b7f79b4d42"
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