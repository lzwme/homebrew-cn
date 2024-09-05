class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.18.1.tar.gz"
  sha256 "102db8120514f7cc3dde93169f2eef1d29aac03babb5ac801ea756a253d6b6f2"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2b0de6ead3359e1529fab9ea0c48a8ddc17f07dc7a7136d98fd4f7c2e3e856a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b0de6ead3359e1529fab9ea0c48a8ddc17f07dc7a7136d98fd4f7c2e3e856a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b0de6ead3359e1529fab9ea0c48a8ddc17f07dc7a7136d98fd4f7c2e3e856a"
    sha256 cellar: :any_skip_relocation, sonoma:         "029f95d4e2a85cfd2a11d8c2bb3a1f792bcb64037eb80a9c0eb664d5f6cb9251"
    sha256 cellar: :any_skip_relocation, ventura:        "029f95d4e2a85cfd2a11d8c2bb3a1f792bcb64037eb80a9c0eb664d5f6cb9251"
    sha256 cellar: :any_skip_relocation, monterey:       "029f95d4e2a85cfd2a11d8c2bb3a1f792bcb64037eb80a9c0eb664d5f6cb9251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ca6376031bc709caaf989b9d3f069308f980406c24880f436cc896631d38db"
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