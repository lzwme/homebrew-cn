class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghproxy.com/https://github.com/FairwindsOps/pluto/archive/v5.18.0.tar.gz"
  sha256 "3e5c8b60d7ee86b9b690b8e197f44c4adef01e6b46b64ea8655875133ffc0d20"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c394fc7c5004881730aae687d6787aae93cdf4eba6a59373dae4129f31d6c48f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c394fc7c5004881730aae687d6787aae93cdf4eba6a59373dae4129f31d6c48f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c394fc7c5004881730aae687d6787aae93cdf4eba6a59373dae4129f31d6c48f"
    sha256 cellar: :any_skip_relocation, ventura:        "7bc4abd52eae2245000c30764fb25878b7d44a7e9d835f15b4d26eb6bc4fed08"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc4abd52eae2245000c30764fb25878b7d44a7e9d835f15b4d26eb6bc4fed08"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc4abd52eae2245000c30764fb25878b7d44a7e9d835f15b4d26eb6bc4fed08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c7cb574988730486040eb8c39e09e3ef678afb12876d455f9f08b991deb5c36"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end