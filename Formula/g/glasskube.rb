class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.18.0.tar.gz"
  sha256 "994bebfd6fd872b2577b0dd1e94167d0c7d0d39fbf3006fc34375376375915ed"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28b23896e188683d7d3d4b8382979af3dff179838ced8062925a608e0274abcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28b23896e188683d7d3d4b8382979af3dff179838ced8062925a608e0274abcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28b23896e188683d7d3d4b8382979af3dff179838ced8062925a608e0274abcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfa3592908b108605b58e0ecd83e683cee48f499febab95aa3ff8883c03dbdba"
    sha256 cellar: :any_skip_relocation, ventura:        "dfa3592908b108605b58e0ecd83e683cee48f499febab95aa3ff8883c03dbdba"
    sha256 cellar: :any_skip_relocation, monterey:       "dfa3592908b108605b58e0ecd83e683cee48f499febab95aa3ff8883c03dbdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a9731a3dd8f771c4bc3b067f5d4d14ae49e86c887e272318f400d40a74e362"
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