class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://ghfast.top/https://github.com/cozystack/cozystack/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "aa7d2af24abff359514077078c5f547844bbff5752ed51299d536c8a8dc4dd16"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd29c05aaf2a3cbb510f296bde68156792f8b0c1b49f0530444c096a7234d76e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e7bc582a218d03303f32120e6ad238afe18081e05090e47fd514950821ea3c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea6db5322c236985435d54d42630ca23979d75fc68948ea2c018da8094bc8188"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8611f14d29442c991cb1f46d9e3f7a4b6f8d55f1cf6dc848f19fdc3f39fdb00"
    sha256 cellar: :any,                 x86_64_linux:      "26007664154059d3737395a15110963bf37aba4da6fedee09842708c574bcb35"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
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