class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.11.0.tar.gz"
  sha256 "9f73a8592c5ff7b78d16c153081348e961df01b9110f3c18f1940d383bde0f98"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "186fb484d56e02e20b2ea822d872e0333fed7ac56af01dea4ffe368798ffacc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "205d64374f23d803b21c83365c61759fe07697fb5d58a4b31eaaa58487823748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1408a99f39007b9e90fdf23012ed7974f478507d59158d7a0730a6e49b199a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3da03f088f1acb25788b7dfce81a35fb272f9023229724b8e84dfa24e649c66"
    sha256 cellar: :any_skip_relocation, ventura:        "77a86f2234d6238fd7ae9bcab593ae9179fcd940d2e994d74268df568268d6d4"
    sha256 cellar: :any_skip_relocation, monterey:       "e2924211bbb8d3362027258117a2b23d8d9d9570fcb87a93d5807bf795258f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea0514e7d0adef91e4058b19197c823e5c27a274b6acc1f63016eaea4b4e918"
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