class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
      tag:      "v0.34.3",
      revision: "5d592aa86fe79b9b6f1c217114a00dca46ae6fad"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "570dec1bc98d9ccb53adb9fa5e16f5940afc34849edf545a4a8fd4161cea2626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa865cb2d0f75cbc88fcc3d1ac96fb7331e9df680b915b2f4effc802bf9e941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c31b280d947e885c7e15fa5e408199f83a02815874abae8c6f1f3ee044ac726"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4642b8081efea45b11694fc4f5f3c2169f6a71802a7c73cc122d135b64e1495"
    sha256 cellar: :any_skip_relocation, ventura:       "8ea5cd6ecff38670e6ad51f1c2cd75010af94e1632056a70d1fa27a5d4cfa247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "127dfb7c8965954d0d0cd21d606e3d5071b795e7a732544d22952fd9bb741a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5178222603cf2e587ff6521013d52fa04e7bb1e79e39e6a51fda650ffe2dcc"
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