class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghfast.top/https://github.com/google/go-containerregistry/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "52f10d0154053b7bdc18bc451a6d3076f4442a664236cb91e8a1258bd210af09"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90c49174b0fe307e2ca2f1ea8ef8972c0f582dba54c5ec28368bde8c75fc5100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c49174b0fe307e2ca2f1ea8ef8972c0f582dba54c5ec28368bde8c75fc5100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c49174b0fe307e2ca2f1ea8ef8972c0f582dba54c5ec28368bde8c75fc5100"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba3b3fdc825357a8c5207585b54b71bbd66536e01811a96f368a157d1237472e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f079e16d967e99f720cea4ca4ffb7f7331ae5a754008dec94cdf63cca079ddb9"
    sha256 cellar: :any,                 x86_64_linux:  "a61c644c8d99b43f2acf5e6f0ff78ce8719ace8254109f9f9f327eda3eac9de9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end