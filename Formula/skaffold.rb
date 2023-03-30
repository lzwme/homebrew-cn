class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.3.0",
      revision: "664890b7f96eb368c1865765f1609cb94f29555b"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b01fba921746df3db159ce5fcfd8f646e3923bd8956470d62702d4610854968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f54ca6c3f546eefed932b98ef6cc2fe5f6ec101181bc917daf84e4d3a16e671a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e50b72e22420e683f7e3670adb84c2e41c51ccf9e464f0082036e5b265f47762"
    sha256 cellar: :any_skip_relocation, ventura:        "ba623fbc1147d1b8025937e737ec3da39b31fb1691c7d9fddfe5fa83f3b84dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "a32d00a7b56099b2eebc05443c278d2fb72006d5b0b294f1feb673d3d91251aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "35097d2c4d2d1a0e063705f757dc88cb804fe4ca11742d1b24d9bfd9689c6994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e5a9de7e6ec94084a6ebb1b8419a6bede94c2a8300adff97997020cc5dcb7df"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end