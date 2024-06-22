class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.10.0.tar.gz"
  sha256 "e1e11c536e2f14c0f75595307ff02129afd2f5d7640eb5c1ec3e1eddabaffeda"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80c4b250219a6bf291f628b9ec6990b841b85091b847f62b5433c4f5ebc432cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2d1a06ed9365d437f3e446fdca691a24f3c0e044b66832a4d8625f0a8c7a4a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e151d3faf232391be836527e2775e23f27d6aa857120e9c8b1cb41d50aa78c40"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b031a3106b993213eb166221a55a686ace1cbf0f0b9f514b0ad6ff6592be5c6"
    sha256 cellar: :any_skip_relocation, ventura:        "04e4b14c1234c53dc1e0f36a6a3b508c635e06f0c18b7303366d00d5780649a3"
    sha256 cellar: :any_skip_relocation, monterey:       "df4c504c75d9d55243afa1b3884efe6e494a20b7ba10deac9bcd16cec0a2b3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ab01719cdc70bf943007fa797caef80dbffb856b745cfd69f6dafaa8ce61d98"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comglasskubeglasskubeinternalconfig.Version=#{version}
      -X github.comglasskubeglasskubeinternalconfig.Commit=#{tap.user}
      -X github.comglasskubeglasskubeinternalconfig.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), ".cmdglasskube"

    generate_completions_from_executable(bin"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}glasskube --version")
  end
end