class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.73.4.tar.gz"
  sha256 "cd283c2447c30ebc01bcbcea22acbbe20472768bc30bcb1e6fb0d75f99293636"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ada4b7c210cd15d9d4288ecafb4c96b95b5ba81bd2f9cc4a9989c07b809126e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d879c69d83721184c07e141635e7de7215eb10b78aa4d0084e4b8eadf9c948e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca24ca9b7043abf6c0bd9f46776ec8e3d23ce326c57b453f234cf0f5340ad26c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cce34557ae58d9376cb5decf02677bc2a9cdfe50e1a7a764774572ced028c978"
    sha256 cellar: :any_skip_relocation, ventura:        "075cb5a945a484fedb6df2c7637be2463bc9fe3d346e768177af41eb6edc62ec"
    sha256 cellar: :any_skip_relocation, monterey:       "9884f2b9ca44a5280e17775a3bcbd394c31815c039e9e2f701e54bac1ed5a91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b32c30a77b3b11c11e3250bb4ef0882426a260b0c80513f882fe208c8130a308"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end