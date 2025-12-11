class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.2",
      revision: "94659f25033af6eb43fc186c24e6c07b1091800b"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11bb696acbaab1a7f095e0eca3f29c10d9ec6bc6f449541a7dd1a7827376da53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98c767e2a7cf9676774cd0f5e5693ede3a21e6c8e15924f69d9237e383ed3451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d034e7f8daea3f3146f6655edd6ca62969a40a9ef99c8e2cf93708d5d96c2c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced129c54329bd5c7b05fc68ccaf6b607c707e327772c95fd023eb7e4c5d01ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "507123d88485e5483726e423bf8a4eb9560f4234b42219a046ccad7e95579942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6883f5f0c0fab20ae1c2318959f74381bf58eb1cfba65b6f3845418f18a3e255"
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