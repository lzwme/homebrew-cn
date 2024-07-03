class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.79.2.tar.gz"
  sha256 "cc6bda73ef23473425370ed4d8fcb98e6729790999cc81d66a815b379141b5a0"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d774cbdb1410771e610e107f88479f642e25ab86ad6e981376ada888d5813f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "701d17c57ef0ebdb52ff9cfd2f8dce49d96493c82d16c1cf005885750dbc92a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73713942de2894250fa9acddbee53087712678893e84108b8a1b27b6085189f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6a2f2e068fd8793e872b6d40d17a3c716f0d89b2f3a1ae99d6f243f6d1b6542"
    sha256 cellar: :any_skip_relocation, ventura:        "7b55c3f2fa1afad512625a3b1eaf86e5053f73358a92df90e8c57e0e5b546b34"
    sha256 cellar: :any_skip_relocation, monterey:       "a54df0bbe82ca7cfeb2c9bd1f61eb0253962fcc35adf9c74543cdbfe95d15376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b3842ed7db85fb10c7f5ed3fe0a0244dc837ebbb6f28400f96adda362ecc1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end