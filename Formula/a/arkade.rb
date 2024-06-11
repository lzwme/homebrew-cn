class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkade.git",
      tag:      "0.11.14",
      revision: "97254cab24f9de320a470e327f2db99be6f2f15c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e7b6de7a97831dd15fa161463a2716dd1e337448a610e5cfbbb8eefbe66de41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97560aa1652b3346fa32751e9f329fb0a533b387fe336bd329a1b31c1a90e99e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e41aa36812b342462d897e708d2dbcc22c57ebee1c1adc788ac2e3c47b668e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f90914f5f7e24cd6ed873f81f62a06b084458f63c4f10f925b761a6ccc50c19"
    sha256 cellar: :any_skip_relocation, ventura:        "98a416ad41387924c6c2e742c64b13a09f193a1479b68857321973bf1c53c28a"
    sha256 cellar: :any_skip_relocation, monterey:       "661cef4a430af2d72caf24568f40334a5edd6742dedf9751fa2049f803b84a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe66d68059a0b3507b0059bb5f6136959a44e771ac16b55beea346478ddad5c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin"arkade info openfaas")
  end
end