class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://sonobuoy.io/"
  url "https://ghfast.top/https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.4.tar.gz"
  sha256 "5e84f5e4723879b613688ce70522fc0423e5fbe2ada5c341484a60f295715af9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "003327422470ffa3b67b2037c837b14ee7f338c319c731d6b4dd4c61fae358fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003327422470ffa3b67b2037c837b14ee7f338c319c731d6b4dd4c61fae358fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003327422470ffa3b67b2037c837b14ee7f338c319c731d6b4dd4c61fae358fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "df024bc4c5420929c972a7ede1febcf4882206caf4202d6ce0af2263174ba880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b375641d906a9521fbe629e45bc3db4e93060176a99ae4bc2da6d6ef338f3b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4eeb97904dc0fa9ef87308feaf8c3c185c662be0602f6870b3305d17406493"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sonobuoy", "completion")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end