class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.23.0.tar.gz"
  sha256 "307096ce6c5be8575bf73285e462974494facbf24c3eefa3a3faea3227743f55"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23f64e6d65b28c48ce8a62fb410c5897ecb8ea95c45effb0916739f25b3d3f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23f64e6d65b28c48ce8a62fb410c5897ecb8ea95c45effb0916739f25b3d3f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f23f64e6d65b28c48ce8a62fb410c5897ecb8ea95c45effb0916739f25b3d3f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e489bed061e7cd5bad7dc09f13942b9554479385f3b324b07d231e00eb1be1"
    sha256 cellar: :any_skip_relocation, ventura:       "d4e489bed061e7cd5bad7dc09f13942b9554479385f3b324b07d231e00eb1be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128930e46210e821fe3eb06f3c15c8080884e8d99726b21388ba7b910edf9ba0"
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