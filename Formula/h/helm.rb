class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.2.1",
      revision: "d591a19b953bd9cfdf7d9ddd83c2f4ffdaeafb29"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c4337a164b678cb91a5c41a6e123a5655da61d327949056a9b52b55be2b22b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d5b93d1e2551e65e5a7df11141e15885554c50c1aa62a8cea76fc9a835a9a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b435cad933fde8b3737b029fdf7486a325091e57ae3a600edf477dbed4e8167"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ee83e533d86a2d728fd27cd2413dd09fa4e140f9cee206eeda908667d159940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9d6781dee7049fb57dfbf77a5f34cd9f1dc6096e78a7b19eec6602999a0c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c1090d8f8f4cabf2840bcf0b1259831e9b72d3677ec460a7e9b8317dd28b7f6"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", shell_parameter_format: :cobra)
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end