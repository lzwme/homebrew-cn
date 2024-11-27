class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.26.0.tar.gz"
  sha256 "93933ab6e7caf0dcc653b2dd44fee44ac4c9153a7141a8490bd417f48ef1d6c4"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80806ac88cd1ebb46aedd509e75b1a7ea36cbd5ebe85f1948ba2ef00b9f19fda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80806ac88cd1ebb46aedd509e75b1a7ea36cbd5ebe85f1948ba2ef00b9f19fda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80806ac88cd1ebb46aedd509e75b1a7ea36cbd5ebe85f1948ba2ef00b9f19fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8dd23f03c68929870bdd9d2847dd5e3924ac4b5466fb29f26dfebf10504f000"
    sha256 cellar: :any_skip_relocation, ventura:       "d8dd23f03c68929870bdd9d2847dd5e3924ac4b5466fb29f26dfebf10504f000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "806e5dee58ab2c268c5ebb57759ba2a5565b0340082702abe24629d3cdca026d"
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