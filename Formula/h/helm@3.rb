class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.3",
      revision: "0707f566a3f4ced24009ef14d67fe0ce69db4be9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68208bd6a46078d4bb5ac4de66e7080082fa7590271e696a2630cfe17f12bb0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f545dc2b09cc8547c0f8990d73a0ea933ed4157ff4e36755879b3c53dee5b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61814194f81ebd2051b79ac0c949c1f546a0606e93dd36d6c75235527c6c5501"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6a19d206366cb57529c7b722b5e46f06d8288dfc37898ba858e370ce18b598"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e78f049534d5f105dce92c54866e901d8bf99a5e84f1875ce1bd36a6fbaefca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8564e8bf3a708538814ed2e780da6f46850207b76fe0ec2ba86329b0d8a057e5"
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