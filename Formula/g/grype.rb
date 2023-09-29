class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "662045a79c1697c9a181ec68133434fa86177dd26435e6998d32d094d11f3ce9"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87d77de9f384fb6e933de789801c701285449672d79b3fdc088b625f350237e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a21fb53f892199a719cf5c7be8590d9412578fc94260eef1773d7fc5c7f2aada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66bc58a07929389af11ab88f161b5ea7d180d40b1e017e4cfafde2b8e2362aeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "258db299783b18911e79945816286f605d57fd5d6b47e16ee9b122e800cf5151"
    sha256 cellar: :any_skip_relocation, ventura:        "b400c9658c58e0c3641590098b06e87d8a17ad8618e1d79dcbe897d8af9b1219"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ca0abbaaa095953b1415eae52d8224c895e46036daf873ce6364c00908b050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e62b3bd9f3900264e1f0ced163494fae375b793eaa432ab77a814cad19069183"
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