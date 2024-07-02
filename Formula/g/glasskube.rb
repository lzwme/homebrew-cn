class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.12.0.tar.gz"
  sha256 "38578fa8ed931b2215757efd01bfa9e1b6f36c9858ea12fd8d94a0dce0522a3e"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "675c59aa274eedb385ed2bcfebf63040c2a883a3fba5a3feb570aa6bcabd9e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81fdffa8ec975375bc4ac47fd835e19a2c4356868e987050fb3cee0bec51fba9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de11fd653c921bd0c5e53cbfc5dde09706a8bfd23edd888334bfc0864a17e85e"
    sha256 cellar: :any_skip_relocation, sonoma:         "af20258950425a2efa89da81b8c7f6fc4abddf8d7890f1dbf73497e34132a26e"
    sha256 cellar: :any_skip_relocation, ventura:        "3e1360af37b92f17c981073b2460554940f9b10dad6732da36b492360d1da354"
    sha256 cellar: :any_skip_relocation, monterey:       "298aaf24a76d9a4683215433c7cd0f6adff0f839926326439be8830641f95c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6664e5bd0763a177cb903e0c796a22840f1aee2e6851b6ecf4f55a5d89e5d6b"
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