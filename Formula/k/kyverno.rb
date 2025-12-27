class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://ghfast.top/https://github.com/kyverno/kyverno/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "95c236722e8cca0fc7a0da8640c42f5df6cec8d9da91cbf892ab27d2a1245251"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f17ef6c6a412b4d23b34302a360804c42c393722931d5b00515a877382d9cbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd49f93b967599c890e481e694a26ca527b18a6ac1d56ca8733e8cbcff9b02f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541036ede99d361a0c635cea1110e68c6ddd8330257b9e6a2576ff488dc8ece1"
    sha256 cellar: :any_skip_relocation, sonoma:        "da3ecc4806c38b8746481053fde56ca4f36ba3d5e05703f5fc5dfebc7367a38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3866eb47bd1e7a6cef252704507c2e4426f8a9efe3bfc5d20c32c51f7cefdb49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0725adc36a61695c97ac24fb711b6d655d98f5a13c3f83d72958121834f0abe0"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end