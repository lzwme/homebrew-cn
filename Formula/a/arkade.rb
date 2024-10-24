class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.28.tar.gz"
  sha256 "8d927f00dd7a6d4f0067847858aac2a34878ded6e266bfc8870510887ec033ac"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783c868be1bcb64894a73b6696828cc03722dda20b338040729f6a72fc829f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783c868be1bcb64894a73b6696828cc03722dda20b338040729f6a72fc829f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "783c868be1bcb64894a73b6696828cc03722dda20b338040729f6a72fc829f91"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7703f913b33f9200b55b0862ec68781c377f79fb61b21ad857bc96f8f246ab2"
    sha256 cellar: :any_skip_relocation, ventura:       "d7703f913b33f9200b55b0862ec68781c377f79fb61b21ad857bc96f8f246ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93b65497d7007e411eb56c50690d2ff6ad5d97c102b99e6023dff3b52c1b98c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{tap.user}
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