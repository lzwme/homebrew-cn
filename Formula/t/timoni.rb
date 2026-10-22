class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://ghfast.top/https://github.com/stefanprodan/timoni/releases/download/v0.36.0/timoni_0.36.0_source_code.tar.gz"
  sha256 "06425e0517dd8e042bdf2af611c5628d16f36b5eb0acee2048dad2ec6164f270"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7624830597020bf51d073ec286f4d45cef52702d31e622254338dc1da4d3a3aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ba85f752a3e37271ca9dc1323b3626528cedea6b21dd9d111b5a832af3535a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57d34f1aa274355cefda39113a57895fd21c17a1c683487311162d6f85485766"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "230ab98c12977c7203d22e1f36c96f503889f4c27e1e427a1f8f042e99ed5d8d"
    sha256 cellar: :any,                 x86_64_linux:      "5367cdc3586d736b7458011109ae12accc4d30cf502b649ce6a43d061d51c1b6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end