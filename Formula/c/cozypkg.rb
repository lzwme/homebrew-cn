class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://ghfast.top/https://github.com/cozystack/cozystack/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "00d57d95f9e5d522bee0f7bd98553ef96e4457880aa7e9e42f21cb49ab34351e"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29af1f948b19b1f6a301e1be22131793998440bd96d7457b5a224bfe992c936e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d432b19ec3c0061487f2ee3f1a9937c84cb97cd2e6611cf8203ff403329a58b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d590fc572bb19a4bdfad525b4119a5d35bbfb108fe1282ed02c0361406570e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44629d6b4c93fd1b98d91d980d4533963af3fa7ddbc1b2318d0b5e55bc05423b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a62e62a7d3ca2f48575e3c175636c13c12088a8b2148f87b31ab4e7087788d2e"
    sha256 cellar: :any,                 x86_64_linux:  "4e9122253adb214048f258b83bd71284d10f09780af1d9efa85ce451c8746699"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end