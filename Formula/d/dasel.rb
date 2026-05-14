class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "58acc3f0f495ce177a0c28d75952f160c013dcb1494ce2d6da91e58c63e99a15"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b961cab0560e1418ad6d6f206fd3f5e830d049b446aebab435a974b43bb50d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7b961cab0560e1418ad6d6f206fd3f5e830d049b446aebab435a974b43bb50d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b961cab0560e1418ad6d6f206fd3f5e830d049b446aebab435a974b43bb50d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4f0c95a93d31489425d31b3f5bde2da829b37d5b5b573d6e8117d8dcb821bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841b7645096d1afffa425efadb4acafcf67d023af0c3d50483a9d1a696ee9f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cda5b19a579baa9592b8b85168b118fe7e665aff05bac108ec213c3f8ac8232"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end