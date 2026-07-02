class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://ghfast.top/https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "a0faa9e2c97c213d427197e3c9ad1bc8a6b038d52ada53e8ba3b620d1b48ba2a"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94d897d9ac56bd82b9de8f688dc4aa273ba816168f2ff0fb4df1fcd8f3c66235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d897d9ac56bd82b9de8f688dc4aa273ba816168f2ff0fb4df1fcd8f3c66235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d897d9ac56bd82b9de8f688dc4aa273ba816168f2ff0fb4df1fcd8f3c66235"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a83cd599eca22445093f8c2a5bf5d6d3f1b299a13115457b68d28d7b366decc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c92e0970e80bb736d2cd5f1341268a87df56c4d1a8d830d975d01079c9e431cf"
    sha256 cellar: :any,                 x86_64_linux:  "768cf8ceee5d722e2162d4a325d0c0adef06dfbb4648d78ae85b5b611af6026c"
  end

  depends_on "go" => :build

  def install
    inreplace "version/version.go", "Version = versioninfo.Version", "Version = \"v#{version}\"" if build.stable?

    ldflags = %W[
      -s -w
      -X github.com/k0sproject/k0sctl/version.Environment=production
      -X github.com/carlmjohnson/versioninfo.Revision=#{tap.user}
      -X github.com/carlmjohnson/versioninfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k0sctl", "completion", "--shell")
  end

  test do
    assert_match "version: v#{version}", shell_output("#{bin}/k0sctl version")

    output = shell_output("#{bin}/k0sctl init")
    assert_match "apiVersion: k0sctl.k0sproject.io/v1beta1", output

    output = shell_output("#{bin}/k0sctl init --cluster-name brew-test")
    assert_match "name: brew-test", output
  end
end