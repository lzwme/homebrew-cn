class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.0",
    revision: "5c63a9f9086fa083255555361bc1c36e8ccbddc4"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d25175bafd18ba0bc6461b8f0db0499869a79354092d886e97234d01d6ba08fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e04c6243e681b8c07e865707eb8dc2768e45243e198800243748296f22082e30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a12c3b0d41cc60632e3055060e51ed9f95f4caa0873dc2f2221c6d0020638d76"
    sha256 cellar: :any_skip_relocation, ventura:        "ff08ceddff356733f675977101633b58f73e3dc374198a9dabe15c32782785b5"
    sha256 cellar: :any_skip_relocation, monterey:       "c09ff4b67b5ae89c91c5c53da147c68b24cd1edc0140bd70af219d7ff28f9370"
    sha256 cellar: :any_skip_relocation, big_sur:        "1471e17af4462bd982381cd1ce94478807a875a3aa739fe8ffced24de358d2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298383857de627d063f41ec916a8a6ba6b69991ad238f6ba74e2b6ec23822f90"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end