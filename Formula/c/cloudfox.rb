class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://ghfast.top/https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "41b95f0d80c5e142f56f498eff94e109a5b6528184a18c0feaa0b6d394398bbb"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f58ed261a29e27825858cd4b99b200d68927589f1fc591c84e986d9286d91e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f58ed261a29e27825858cd4b99b200d68927589f1fc591c84e986d9286d91e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f58ed261a29e27825858cd4b99b200d68927589f1fc591c84e986d9286d91e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b44ac8a7e14b3c0bfa0f1be104220fd8e0cd965bcba200984892c7dc2a07e3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9220bf69db639a1c07eb534963b6ee780b56a7547ad182ed6bacda9487f90fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b5ae1d70456eb61bca41051b6541a577e9834f76a57641b14f8f69c964ebda9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end