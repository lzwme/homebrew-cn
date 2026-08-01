class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghfast.top/https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "29a1b525881f89bf07c50537e40ea3609e2fe5d6851b9f62cf7452ab1104445d"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e9302d89eaee2226468f347ecc2f2b75a8e108701738c564f7c2ca9bafce7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e9302d89eaee2226468f347ecc2f2b75a8e108701738c564f7c2ca9bafce7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e9302d89eaee2226468f347ecc2f2b75a8e108701738c564f7c2ca9bafce7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a499285047cb22eb174fbb7319d4c32610e12fc6a96e14a9f95582dc3ca40ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63f1e4e3bae4942d883126b39c139177a15fc11429748620bcd9dffddaa667f1"
    sha256 cellar: :any,                 x86_64_linux:  "85ca40fef1b22974e1dd1bb5e6f00ecb31063d853bf2e39d40f0856a3e51876b"
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