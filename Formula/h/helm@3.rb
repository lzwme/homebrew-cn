class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.4",
      revision: "7cfb6e486dac026202556836bb910c37d847793e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "204902c2af2d77ce6bcad91a9bc280aaed1402c30179a573a811aec7147b6b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d740da22efd1000634940fbf2beb6e9f15f81491db90343fdc405ea1370b8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24cbe7a36d186c1179622a99c3b7ec3cd137d82ab7acf58e61dc1cf5f4536f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "79854d6dc9ab27f41270754f96bba3ae31d9063a40fde9733177be4843451a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5146c418f65d21776b2d6c37f5a58704d2aab553089ecc759dc31d152301b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6ab8035d3e050efdad3594affc600e0d6b693813cde95469974ca5bfe9d752"
  end

  keg_only :versioned_formula

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