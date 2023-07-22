class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.2",
    revision: "b544af3682599ed45d2d19debbb1d407608561c1"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec28f944c75fd8863858ac7d79c700f48ded3b22726bf053e2d8abe2153fd97c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38f42b37e78f9f6123b42fb6c242dce01b69e9188e1311c678ede72e20f995df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b183c73cba69b6aa273375abd851cb713622918e6841abd9ecde2e5a5c87c3c"
    sha256 cellar: :any_skip_relocation, ventura:        "ebfd1f5f89e6f2b886c7ed6564c0a39b6c56b917d79c5148e94098291c81b8f2"
    sha256 cellar: :any_skip_relocation, monterey:       "657d391355791ae721666cbb1645bccd8ca5ae93be34dd01728b7087e6f6de59"
    sha256 cellar: :any_skip_relocation, big_sur:        "98a3b088bde4b0b4bc93324b92d0babb9984c154d24c778e49b16f3ab14a83c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7a18abf03079b62c1fa66eaad5ce8ef34c05189de98544525ecd9162f7fc8d"
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