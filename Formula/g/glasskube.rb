class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.19.0.tar.gz"
  sha256 "c2df659290049d19347cbd55961db2b8defe94db86c36ab1b482628280ba2a19"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "698ce683b04c5a7e9ed54f2ae4d24b4e3b3b486569aaa4ca036dc11ea24168ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "698ce683b04c5a7e9ed54f2ae4d24b4e3b3b486569aaa4ca036dc11ea24168ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "698ce683b04c5a7e9ed54f2ae4d24b4e3b3b486569aaa4ca036dc11ea24168ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "c21e450006014092da444c18b4df31ac1ae6f313e670b65318d1ba4fd6eeb542"
    sha256 cellar: :any_skip_relocation, ventura:        "c21e450006014092da444c18b4df31ac1ae6f313e670b65318d1ba4fd6eeb542"
    sha256 cellar: :any_skip_relocation, monterey:       "c21e450006014092da444c18b4df31ac1ae6f313e670b65318d1ba4fd6eeb542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f276a11a4340275d9d80d3e75fb2f65e6af722c234b0551ebe7f53d480ba703"
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