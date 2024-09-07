class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.20.0.tar.gz"
  sha256 "4f9044f92e9736a4e8d70cb9a42b2becc4d2dcd995a82c48b45de7372e4db0af"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80bbf9d529964b063f0ec3e477a66966b7d6310e4f277833f2d11eaf606b9da9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bbf9d529964b063f0ec3e477a66966b7d6310e4f277833f2d11eaf606b9da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80bbf9d529964b063f0ec3e477a66966b7d6310e4f277833f2d11eaf606b9da9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7e73deb32906e7e55b13067767bc89ce6c970ea4f3059ce78faa9acaf002a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e73deb32906e7e55b13067767bc89ce6c970ea4f3059ce78faa9acaf002a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e73deb32906e7e55b13067767bc89ce6c970ea4f3059ce78faa9acaf002a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a3b87c1a02b333022fe950fdbbd68311bef891cd0ef4408e6c2784e821429e"
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