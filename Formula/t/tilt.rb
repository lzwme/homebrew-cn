class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.8",
    revision: "62f1fce915ff87fc4889a2138bfee9525ce90f89"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15b1943ec800d21f19617af851b0fb7ca4484ccf7461547bcc812d1e08e1d499"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd261eb74011de64911cb22e6d56be94843cc0571628fa84d7245cf92a3aa729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6f5f7fd45a13a1e32f3fdc34d9b5dc7b0bf519dfc0ee474a780dd60a78e26c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cebb3cccb1d5738381d2f7ffd1eb2f172a4457c3bb555e01636da0f1b8117092"
    sha256 cellar: :any_skip_relocation, ventura:        "27857b2c4f1eb1cdcaa140bb567612bb7d701767d64a4551fbf4d25ce902f082"
    sha256 cellar: :any_skip_relocation, monterey:       "120c3b873f466834b6241bb09fca1d17ec575e4026eae859a81fd00cb8b87843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "218b8131b502a4e556599e5c85743e5571bc8a85ed7746013bc3a81c25e26f3a"
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