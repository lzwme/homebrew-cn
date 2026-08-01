class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://ghfast.top/https://github.com/stefanprodan/timoni/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "7952da3ef6b3d8df4ee596550e638afa9a5c41962a794eb9650f33c0f48e8244"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d1f2511d7255a73ef91e1b3c9ce65e966d0f367700a75fedf3438c3a505af5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb4a8858aa5f57afe1e95a164ee837eb5f5249be072614b5ff3742d010826d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382bf210fea6d539da086edfb05006f1cd0a492615a3212c2e1c1be290c4b97a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c6504cc3aee12da5ab9487c95afa3263b2e4fc093a5257d07ac050f297c03a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea966cb5038f6f36894c93aa102c98517238a091c5a59cac239a67d866461e94"
    sha256 cellar: :any,                 x86_64_linux:  "47b6983bedd5b33eac017b2a1e256bacc1d11c035f115956a31762bd3556d93d"
  end

  depends_on "go" => :build

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