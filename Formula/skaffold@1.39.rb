class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.11",
      revision: "8b817ab4bac398e2e935e838446700ca42a713b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75a51d0a8c7df98064e13ab92db5b013fa7ab119fc404fa928fbf7aab252ffa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ea57a9c21ac88c7185d61ae712ba94586de91c29a6d7b1429119f53bd1e1699"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180c1f3272004e6ae1c85b7cb828e45d38ffccf84bc1c4e24964c333d8f95202"
    sha256 cellar: :any_skip_relocation, ventura:        "971efc6ed3b2502ea9ee59bedb6df0403fff61fbd788d97b43e9fa9231f6f774"
    sha256 cellar: :any_skip_relocation, monterey:       "14d8ec2510a6ecb236b2b3c69d81a1eb5b10d3c696f87e68ec41b2674adcce3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6442fe36305893cca30377f7a8fb1f2f6e961a31245501db62de02b277e9006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48779bfc5d4322631f368a70ae20a824929d2c892eede01ee312fd5980bfcb2c"
  end

  keg_only :versioned_formula

  # https://cloud.google.com/deploy/docs/using-skaffold/select-skaffold#skaffold_version_deprecation_and_maintenance_policy
  disable! date: "2023-10-18", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end