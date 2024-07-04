class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.12.1.tar.gz"
  sha256 "1d3fd9a1fd4245c00e4c9ea7ff8ff1b1a677270407f84a4f4b1fac128fee104d"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffc7fecb253d19828ed33100881b639ac5804e122d76b2ebd76e51e9cb484844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab3d28cd8e5e7c03bc0c4e528db997c6010aa34880106ee85603df554821892c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3591efc22e929404f0473ec51a97341f1a21cae6b2828155a79ff13d8686f13c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbc63dcf18a1aa1a2104e6834e363b0436db8079080812c9f45a3c63dba38246"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e10ab851d03c9ba29da07172ef8b2f3846b213bac24d98314aaf6ae55fabb5"
    sha256 cellar: :any_skip_relocation, monterey:       "42f5c41f911e0222f0712e2033db8c6f8cdfc5ed14e1b9351f366acb702d83cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b21cbac86b0288742300eeda7ea5c80bdc716575e3f0bbe5f0c170e5d91330"
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