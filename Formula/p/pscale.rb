class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.341.0.tar.gz"
  sha256 "edb52d569fc587b554fefe6c248d33e1da803ef890d8fbf8f51837364d18eec9"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "074f8d0adf534bf18192bb2b91765d0a1bd1402a06e28347e538386605a64aac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7a4fe667c450eafcbb3ddee085a0ea866d0ad5d450f0bded0c26166914906ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec14a295d145d181d523c7ab63ff24616e1adb621082c755cf260ba47ba55e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2378be7bf9cce52ca499afd1cecf0141c9707bd08f02dfefc5a0b27793d11568"
    sha256 cellar: :any,                 x86_64_linux:      "38168dcd5edeff1ce16668e80ec5418461158f2bebfb26a9f1e6237448f60096"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end