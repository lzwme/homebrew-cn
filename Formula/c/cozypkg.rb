class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://github.com/cozystack/cozystack"
  url "https://ghfast.top/https://github.com/cozystack/cozystack/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ab8696620f130930df8d588956c47a6b2a582801776eed23b0ebf8bdb09f3eaf"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fdac8cc61de1b2968d981305a05e1bf03eafdbc0ff1afff24fa52219096a0c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf18958934fa0bde74c25b9549fa8f19d7a4b4123b86841ad524939b9d25ad32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f521fd68b45f9ee79cb624b87ed544d6b93952222d986bf7e0aeadfed0e7ad6"
    sha256 cellar: :any_skip_relocation, sonoma:        "157eb568c0e02a0df0cf4e52a7c2e4c24f0d88669a654c0f27a985954c2fb0be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf5d4b026ae7bae5a5012871c91d494780ca449c73b51ff18fc472e4e36cdeb"
    sha256 cellar: :any,                 x86_64_linux:  "426a0b583aa99a1d2dde23f191962efcbd772e7515219c9e0ad569dcf797aca6"
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