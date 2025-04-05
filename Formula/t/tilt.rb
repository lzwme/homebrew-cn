class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https:tilt.dev"
  url "https:github.comtilt-devtilt.git",
      tag:      "v0.34.1",
      revision: "161ad54b256a91c29b4efaa9cd3a12bf45614441"
  license "Apache-2.0"
  head "https:github.comtilt-devtilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb6ec1e5d1c6d1119793dbea91b3e4dfa4054ba675616bf795ab85341016de3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c7ae875611719bbc295e822e8445e3a9bde73338f058289c570de1e8b4e38b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a6ec9d1aa8bf5083dd903f27212ec2db9095312f7c33eb497835ea11b96f220"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a91e4af05da120acf856600021b67b304f5eac93fd3c9c01a592af7945dba0a"
    sha256 cellar: :any_skip_relocation, ventura:       "19d1fb86531af8aea4972fd03413201750dbd823b14877c3f756cc3c2102b433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72e3445b95e04796313d5cfcdf87e7cbd6447f2f578a2c2594fa18100e85b6c2"
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