class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.17.tar.gz"
  sha256 "9425557e51ec9e855154cb94b7fa13ab4cbbf38fd21748b31045fe55d0db1635"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c305522e4df9f7c2a3e984d939f679738c24258c725e72e1cea2354b5494d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c305522e4df9f7c2a3e984d939f679738c24258c725e72e1cea2354b5494d04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c305522e4df9f7c2a3e984d939f679738c24258c725e72e1cea2354b5494d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "1620dd2aed3b963b185ba65023536dd77ae870f96aedc5f13eb701dc0b8243c5"
    sha256 cellar: :any_skip_relocation, ventura:       "1620dd2aed3b963b185ba65023536dd77ae870f96aedc5f13eb701dc0b8243c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb15afc7bde0b1f0fd18e80a540615845a83670e88360e65b00a3ff9bfe7836"
  end

  depends_on "go"

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end