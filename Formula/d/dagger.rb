class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.16.2.tar.gz"
  sha256 "fb1a1183674d0b49ee6064ca2c94503496b529b2d83c0bda377bab70238d6c56"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25a7a0fd3a68e0060be4bfc276e6217519416678f786264fdb9634511cfbedbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a7a0fd3a68e0060be4bfc276e6217519416678f786264fdb9634511cfbedbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25a7a0fd3a68e0060be4bfc276e6217519416678f786264fdb9634511cfbedbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3e4cdc9a0a445fa348fc88f8188ae63bc0187b140e0aa8a331a95d0e96163be"
    sha256 cellar: :any_skip_relocation, ventura:       "a3e4cdc9a0a445fa348fc88f8188ae63bc0187b140e0aa8a331a95d0e96163be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0128469c9f11a48721ddda529735227b9e2f0571e07a962271c1dc682b9470cf"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
      -X github.comdaggerdaggerengine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end