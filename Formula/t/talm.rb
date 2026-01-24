class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "438faebe66c5bc2c33f9009b8f6c79c3a7a01227bd3531c9614e4af575c046c9"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f4e973bb127ac664d23bdf740143bc0ed364443440e2701027770919f986ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5b3d0f9791bcadf29e2966f3b8a7b437a8181f773fdf8e5994f69406c2fd60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53acff3b48b870084cbef1f2c4440e09641549c794a66a713ec7889d0937b4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "43381cd59ce9e05885e7fbd7476dabefbef64a7dfbccc1ac2f5b30097d7b40d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06818bf00f8bd09136f36b01485ae8f03be115a48bedbcf7289b1f2110821ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac8ec7b38ccf7ca59ef9b90dc0a3adcf4bd29def132ff1fc5add8c6da2c3dea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end