class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.7",
    revision: "5121d729c0f813f471d44ea3f9a5a93272c4393f"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f194080ea392b60968600b5e52a000b6d29df7745b528b5d970a268eb0600e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21bedd8bb0a267546e803245663e1ad9751810d06fa515ecea3b279cc52001dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ad4c7736aa1409225fcafd56fc793ef7746b3ff7a18a0a0f236a1cf0c76ab6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2702c2144b87407158c57225bd0464b1d621ca09834c02d0e0f0351fce69c48"
    sha256 cellar: :any_skip_relocation, ventura:        "0d2dfc55184c29bd03cfb9a04d7096761b14cda32cdcc258f0f1a98c9dd378e9"
    sha256 cellar: :any_skip_relocation, monterey:       "719fbcdc341ca6add2a53422e61a3f5b76b43c509ac2c402c4e6d99abeec8011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a0cf2b8e1641d293f1353a7042954c0b8331e9c6cc0312655fe550faa4df6e5"
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