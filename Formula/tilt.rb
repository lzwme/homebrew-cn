class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.32.1",
    revision: "ce8d0d674381f7be54bf04a46665c2c3173bc5aa"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "878a84594f3345717c6b24efedfd2ddf3aad8e815084286727f704b3cec50ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af92cf4fe01f98a534527aa361e758398c4fa12a40a12fbce08d757fceb2184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b798418cfacac2f38a7ca13099931ab3dd63a5141204e347f4a29dcea2c535a1"
    sha256 cellar: :any_skip_relocation, ventura:        "dc27888635019a9b84eaccbdfc49094303e7ed835207abc64f802c97c57a7d18"
    sha256 cellar: :any_skip_relocation, monterey:       "11c4325acca24a507705ab0542703f460f4a6acdca53a7dd8637439f3039318e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b335098c27fb83ad7e339827fdd434d303e13a076bf3f855bfb5c60762932ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31087c80acb1c3f029720883aec2a1c7c33e74657fbbbb0ea0770c56b1de3adb"
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