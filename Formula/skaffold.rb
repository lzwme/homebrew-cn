class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.1.0",
      revision: "c037d6f51276e178a2c05c1c59665956ff34aa4c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f60f2374710d54762e8e0d5cf25793980411cdf9ecfec10085785f84e253e47b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4102990f228e02265e52cdd6a1cf380a14d981673d2b745523297e765befcb29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faa59bdce824e7ae3d1c965cf73c6ea0b4225dd2b160f2241f122edc16f4066f"
    sha256 cellar: :any_skip_relocation, ventura:        "fede808a5437920e66fb6578a5ae724fe87df60f64a75caa673cf94176f69b29"
    sha256 cellar: :any_skip_relocation, monterey:       "33b31b0d8068139640feaa38182c6d8f173a0e62afd2497f273e6244302c5103"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c98a140c81d14c8737b477a31c0e8e64a515a3ba9668ee52601f1c9ed88fab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca7dc50074b37c22ae0a24bf5c0c725ceb02dccc49159328dbf19c20d1afa6a"
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