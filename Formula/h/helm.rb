class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.1",
      revision: "4f953c223ba21103268e0b664c64240bc69fced7"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bee107be9aa60f278a11ca0f791e79e9d90b4e2d61cbe39ddb59d8605fc7f737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be80fb6dc02b5adc8bc0a784eb1fab2e4d3d2c3b0b3d656b8de8e770db1f5900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89112fadfa1e5fc1a4b4ad7e38cb8105d001b33e7d98a378d7b78f67686752a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "19844f32a78c584ff70ae51ee508d7c1ab12f164b379847d1fb7001392e57a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc55cb448f8f9c51e53be210fc4f9536204eabb1cb8070bea1caf32c514d4590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3c42a1aa6e7bebc028282cfd5249acd02e96d1e2488a6c6508595677f9742b"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", "completion")
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end