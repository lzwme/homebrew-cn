class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.7.0.tar.gz"
  sha256 "765a7810be65e4a7fedbf332cae74c2f92581e378f2efbf5282dad4e410c9eee"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8890c90119c2e1c08454fa97a086b705bbfc162d0dd97debb0a55ef4d6c57817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27aa9ab72fe1dc50e4ccdc68a70f8067d555b9afade5731f2114f24c4595dc98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d27de1d5f26c8c0f0a443b3d990651074ee24b7871787165d713f1d83ff116cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2ce2d2299df6051efdf4fdb309560b7e7a021010134114a67f5f3a03273d2f0"
    sha256 cellar: :any_skip_relocation, ventura:        "a3e37844df374f3b86789b73d4df3782446fec047e77cce0587cc548e26a6c8f"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d856d64d343fe4a5db8dc3e95867bc7833d4affa7658e0bd249d81797dba83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b53f0bf0919498ecfa60107d5efb581f5560cc7881754ada4b0a7e6018e2079"
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