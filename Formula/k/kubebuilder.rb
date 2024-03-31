class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v3.14.1",
      revision: "cc338d729c2a578ae491860e3eb71e63864b1390"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b72b5306d145aa698176f6e5ded3a45bb48e102e96ad2294a4882a066a19b9e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "102422ae2c6127dc4119d7d319cad138af65c81d032dc50926847e20b0b68212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1385f8169a5c6726c212c6462e7ee570c8877b6ff7711bb00920e657d27575b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c667788b88ffd34a80d092e48490f3051d3938435dcdc5bb0d7bacf9c055d954"
    sha256 cellar: :any_skip_relocation, ventura:        "3e300d21e54fefb78f739768da4acfb43c11b3e3e8b1eeb479bce9e0f7756aef"
    sha256 cellar: :any_skip_relocation, monterey:       "6774c35beed9c997b39e93ff3df5039c312b593ef2cad0a2e99ae649f70a6c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6277805b813539430ea0946be8c93c3da7f5cf32b031f6ce3cfc701055d83e1a"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    ldflags = %W[
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmd"

    generate_completions_from_executable(bin"kubebuilder", "completion")
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}kubebuilder", "init",
        "--plugins", "gov3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end