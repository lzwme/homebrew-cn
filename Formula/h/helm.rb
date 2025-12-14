class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.4",
      revision: "8650e1dad9e6ae38b41f60b712af9218a0d8cc11"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4931eb04f1883cfb38398dfa4f50cddc71753f4d29b1111eb6513faf62e3484b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3559b0d4b8119c0320fcfce8d074d20d3b06e22ea8133cd3d801451af369662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6146e36e29f0931724bd4cba6c8ef6c7cdc9772d5df8c885a18f58b942ac58"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e3da6d7e79ab645c0bf80eb841f88b9fd0b2d1885285f51603822e12b0ff497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83781c77532654a3c0756ecd29035d1d33d84307b67b5a4497af98c841cfe7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b392347b5e3752840fd53043348ea2f220cc8c6418885ee0c2add442e57bbfad"
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