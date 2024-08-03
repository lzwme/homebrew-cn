class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
    tag:      "v0.33.18",
    revision: "80d41343d7940e7517103bc617ffcc8b6e505dca"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bb6ed783a13932e6422d797386286dfcffff59c7e95f668c654afe6ab33931d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ffce220beb4dd3cfb7bf15b54b7cf640f4289c07d2f97961b83266a7834e845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921d583868d0ccb40687e71ccf6c72a8d8909b1e03ae9bd92be609bce173094d"
    sha256 cellar: :any_skip_relocation, sonoma:         "08e8086cbee460bb7cea49b967c6147cf993b2312c56087cb61b3d7566ef385e"
    sha256 cellar: :any_skip_relocation, ventura:        "5ece29544ef61e19b6cb13ed2c67e440648bf96bb69b06c10b22cb8538fef852"
    sha256 cellar: :any_skip_relocation, monterey:       "9a730700551ca1bb23ad44f243a29aa29057033cd474030ae4c5c68a79c95d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ef066696b9181b07f7561cbe6eb50715f2951cd3fa90a12462511b6a876a40"
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