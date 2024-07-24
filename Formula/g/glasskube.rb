class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.14.0.tar.gz"
  sha256 "f858565fc9003d8d2a19bb0076b6f5186a68eb08b3b8cd169ec473f4ddd11093"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d4b187afdcb20de28824bd3dec6fce5124c001c96308e9e0a53eabbb232f6a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5475ebf4854ddcc7b836b58964ef5b8b229bd65ac6c1a9dd0244ef93dd145476"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9931de3b4b262dbae5f94f9dd4e117b7e6145603d8f1c004530b6b71976f2acb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4436100f17a5130f2b99e4a1972d360eaa14d7efeaede8001f655dd1b1a7bff"
    sha256 cellar: :any_skip_relocation, ventura:        "140610c32f532992daaba1d99b08f3f05b4d82e82ac2c48692d4dc21f7767c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fbde69c99c7824f75b68ee8c92fc07d8bf5a1ff8d42eb086d360314635d760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f88ee959fcb50bb90f6451ee6519ed9164030939548d4b0ca779dd26098bce"
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