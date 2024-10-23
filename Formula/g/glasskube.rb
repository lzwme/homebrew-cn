class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.25.0.tar.gz"
  sha256 "fcd6bbb2f964a74834e230db6426f9096b7f6b2f4ae0ce241b4c17a1d15d2c9d"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26434ed3ab1f2f5945b6fd34a27fc50f784f2aa8eeb70809068f5c951b3a4c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26434ed3ab1f2f5945b6fd34a27fc50f784f2aa8eeb70809068f5c951b3a4c4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26434ed3ab1f2f5945b6fd34a27fc50f784f2aa8eeb70809068f5c951b3a4c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "663656e3fe152032e25b9c0bb91e6f51214fcdc7a1d42eca19ceae5c691d548d"
    sha256 cellar: :any_skip_relocation, ventura:       "663656e3fe152032e25b9c0bb91e6f51214fcdc7a1d42eca19ceae5c691d548d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9ea281153ed4389e2ba5f4200f50896394ca00095716b691b759833273ad19"
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