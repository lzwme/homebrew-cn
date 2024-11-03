class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.57.0.tar.gz"
  sha256 "737a24712b10d9be13ec5a2e7441588acdf4533c12c950d330649079e5418ba4"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a2687300ebdc40722b05151a7a4fc46967ac1f9c2c4518817fed01e3e87599a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c144a8fb3d9e0dcd9fbbae93c3756b3a559bf950a05a0fc59c52cc8bca25509"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2d82a0eddbfc49e808f21570c1c1f25132f13fad55721e41139233da7c26753"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f4d928c6320d0828551a00db6ce2ee7f91a3115db242e55cdcea4a72dfae04"
    sha256 cellar: :any_skip_relocation, ventura:       "270d9b60ef00585ca55d679465f2347dc08ccdf5298a64c6347af631fa4dde89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1433fd1c465f68a928bda9668d117d87cdcc72c4c7fb3fb2cbb2ac7206ffd890"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
    (pkgshare"templates").install Dir["contrib*.tpl"]

    generate_completions_from_executable(bin"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end