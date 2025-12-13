class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.3",
      revision: "9db13ee5c343196f642c568a03e58d3221b324d6"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f1dd7c59d99bfdb079eef19112b7283f997a76259c5f2817b55e92c3995264b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41431f1ab63655389412090e740482bec669c578d85bcc9da08cc8711210ef81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00bf92dd28ccd4474578824eee46c87678f91594c377ee39a063d78aceef13c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f94dbaf43f3b39da0457bcb28d81983da8ed92ef94a8e29d5c7ff40700f4de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da32a9c6bde1ddd317c556ab0df4a7d6b9f827fcea03c449a68e810d3b908a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2aa2d6205087d1f03d60b38714713c7ac7c68373ec7abec69fe83908edaf8f"
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