class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https:www.descope.com"
  url "https:github.comdescopedescopecliarchiverefstagsv0.8.12.tar.gz"
  sha256 "2d41eed7b13e2872a762d703588d169a92e1cdcd772dcfb9b4a5aea63e626a69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07783b013845132a0038eb043aea7b2d74d722619a8c125e24ca126e999a2b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07783b013845132a0038eb043aea7b2d74d722619a8c125e24ca126e999a2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c07783b013845132a0038eb043aea7b2d74d722619a8c125e24ca126e999a2b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "852a000cf19c5021c184e52604964ce26b7bb770d6251d5f0918ad937eaa875e"
    sha256 cellar: :any_skip_relocation, ventura:       "852a000cf19c5021c184e52604964ce26b7bb770d6251d5f0918ad937eaa875e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a8741bd2a4054b6e672e497a90f22c6ba61712a66a256f8fa0e89d07426ccb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}descope audit")
    assert_match "managing projects", shell_output("#{bin}descope project")
    assert_match version.to_s, shell_output("#{bin}descope --version")
  end
end