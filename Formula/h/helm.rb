class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.13.0",
      revision: "825e86f6a7a38cef1112bfa606e4127a706749b1"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da4b64184fe64f8b105df5b99c1b431f0d92537b49183286c9001af964723916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c2ec7d7bb0387d47aa383e20bc9e747ebd7dbe2b7d0a7332b31321bb2ba6443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b220a8205b7c12d37631bf881a655cddcb5a2a604b89d92f13424b652d6ec2ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6ad8cc61486ac5e274b5fa551bb02e3aa17f0b50b12240c8985c4e994ed7541"
    sha256 cellar: :any_skip_relocation, ventura:        "d41b85d5f8fd27f2c2e48aa1e4873fc063550b3fbccd3f958e148ea5f39f99c4"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba01aa2680ebcb9df35de8e970271407371511f24ea26befa369e3211a22ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef05a9dae9a7316fdbfba7682186b49c9db27d479fa550f54d53502ba09e252"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

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

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end